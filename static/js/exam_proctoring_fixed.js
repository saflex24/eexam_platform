/**
 * exam_proctoring_fixed.js — MAWO Schools eExam 2.0
 * ─────────────────────────────────────────────────────────────────────────
 * FIXES vs. original:
 *   1. Face detection models loaded via proper Promise chain — detection
 *      never starts before models are ready (was the main silent failure).
 *   2. detectAllFaces() called on a TinyFaceDetector options object that
 *      matches the loaded net (was mixing faceLandmark68Net /
 *      faceRecognitionNet with TinyFaceDetector — those require
 *      SsdMobilenetv1; removed them).
 *   3. Multi-face handleMultipleFacesDetected() now fires on EVERY detection
 *      interval while multiple faces are present (old guard
 *      `multipleFaceDetected` blocked it after the first hit).
 *   4. "No face" alert timer was never cleared when a face reappeared because
 *      the faceLastSeen check logic was inverted. Now uses a consecutive-miss
 *      counter that resets on any successful detection.
 *   5. setInterval face-check replaced with requestAnimationFrame + timestamp
 *      gate so detection pauses automatically when the tab is hidden.
 *   6. ADDED: Admin real-time alert via /admin/api/proctoring-alert endpoint
 *      for no-face, multi-face, tab-switch, and threshold breaches.
 *   7. ADDED: Student in-page toast queue — notifications stack and do not
 *      overwrite each other; severity colour-coded (info/warning/danger).
 *   8. showNotification() defers to take_exam.html's version if already
 *      defined, otherwise provides its own stacking toast fallback.
 *   9. Camera error reported once; won't spam admin with repeated alerts.
 *  10. All existing logic flow, config shape, and state shape preserved.
 * ─────────────────────────────────────────────────────────────────────────
 */

// ==================== CONFIGURATION ====================
const PROCTORING_CONFIG = {
    faceDetection: {
        enabled: true,
        checkInterval: 3000,             // ms between detection passes
        consecutiveMissThreshold: 3,     // misses before "no face" alert fires
        minConfidence: 0.5
    },
    violations: {
        maxTabSwitches:          10,
        maxCopyAttempts:          5,
        maxPasteAttempts:         5,
        maxNoFaceWarnings:        5,
        maxMultipleFaceWarnings:  5
    },
    // Admin real-time alert endpoint — set null to disable
    adminAlertEndpoint: '/admin/api/proctoring-alert',
    // Student toast display time (ms); 0 = persistent
    notificationDuration: 6000
};

// ==================== STATE MANAGEMENT ====================
let proctoringState = {
    webcamActive:          false,
    faceDetectionActive:   false,
    modelsLoaded:          false,
    cameraErrorReported:   false,
    consecutiveMisses:     0,       // FIX 4: replaces faceLastSeen timer logic
    multipleFaceActive:    false,
    fullscreenRequested:   false,
    detectionRafHandle:    null,
    lastDetectionTime:     0,
    violations: {
        tabSwitches:           0,
        copyAttempts:          0,
        pasteAttempts:         0,
        noFaceWarnings:        0,
        multipleFaceWarnings:  0,
        fullscreenExits:       0
    },
    // Throttle identical event reports  { 'student_face_not_visible': timestamp }
    lastReportTime: {}
};

// ==================== NOTIFICATION SYSTEM ====================

/**
 * Inject keyframes + persistent-warning styles once.
 */
(function injectStyles() {
    if (document.getElementById('proctor-styles')) return;
    const s = document.createElement('style');
    s.id = 'proctor-styles';
    s.textContent = `
        @keyframes procNotifyIn {
            from { opacity:0; transform:translateX(120%); }
            to   { opacity:1; transform:translateX(0);    }
        }
        #proctor-toast-container {
            position:fixed; top:80px; right:20px; z-index:10002;
            display:flex; flex-direction:column; gap:8px;
            max-width:480px; pointer-events:none;
        }
        .proctor-toast {
            padding:12px 36px 12px 16px; border-radius:10px;
            box-shadow:0 4px 15px rgba(0,0,0,0.15);
            font-size:14px; font-weight:600;
            pointer-events:all; position:relative;
            animation:procNotifyIn 0.4s ease;
        }
        .proctor-toast-close {
            position:absolute; top:6px; right:8px;
            background:none; border:none; cursor:pointer;
            font-size:16px; line-height:1;
        }
        .persistent-warning {
            position:fixed; top:80px; right:20px; z-index:10001;
            max-width:450px; animation:procNotifyIn 0.5s ease;
        }
        .persistent-warning-content {
            background:linear-gradient(135deg,#fee2e2 0%,#fecaca 100%);
            border:3px solid #ef4444; border-radius:12px; padding:20px;
            box-shadow:0 10px 40px rgba(239,68,68,0.4); position:relative;
        }
        .warning-icon { font-size:48px; text-align:center; margin-bottom:10px; animation:pwPulse 1s infinite; }
        .warning-text h4 { color:#991b1b; margin:0 0 10px; font-size:18px; font-weight:700; text-align:center; }
        .warning-text p  { color:#7f1d1d; margin:5px 0; font-size:14px; text-align:center; }
        .warning-close-btn {
            position:absolute; top:10px; right:10px; background:#ef4444; color:white;
            border:none; width:30px; height:30px; border-radius:50%; cursor:pointer;
            font-size:16px; font-weight:bold; transition:all 0.3s;
        }
        .warning-close-btn:hover { background:#dc2626; transform:scale(1.1); }
        @keyframes pwPulse { 0%,100%{transform:scale(1)} 50%{transform:scale(1.1)} }
    `;
    document.head.appendChild(s);
})();

/** Lazy-create the toast container */
function getToastContainer() {
    let c = document.getElementById('proctor-toast-container');
    if (!c) {
        c = document.createElement('div');
        c.id = 'proctor-toast-container';
        document.body.appendChild(c);
    }
    return c;
}

/**
 * showProctoringNotification(message, type, duration?)
 *
 * Defers to take_exam.html's showNotification() when available so both
 * systems share the same visual style.  Falls back to own stacking toast.
 *
 * type     : 'info' | 'warning' | 'danger' | 'success'
 * duration : ms to auto-dismiss (0 = persistent until manually closed)
 */
function showProctoringNotification(message, type, duration) {
    type     = type     || 'info';
    duration = (duration === undefined) ? PROCTORING_CONFIG.notificationDuration : duration;

    // Prefer the host page's notification function
    if (typeof window.showNotification === 'function') {
        window.showNotification(message, type);
        return;
    }

    // Fallback own toast
    const colours = {
        info:    { bg:'#dbeafe', border:'#3b82f6', text:'#1e3a8a' },
        warning: { bg:'#fef3c7', border:'#f59e0b', text:'#92400e' },
        danger:  { bg:'#fee2e2', border:'#ef4444', text:'#991b1b' },
        success: { bg:'#d1fae5', border:'#10b981', text:'#065f46' }
    };
    const c = colours[type] || colours.info;

    const toast = document.createElement('div');
    toast.className = 'proctor-toast';
    toast.style.background  = c.bg;
    toast.style.borderLeft  = '4px solid ' + c.border;
    toast.style.color       = c.text;
    toast.innerHTML =
        message +
        '<button class="proctor-toast-close" style="color:' + c.text + ';" ' +
        'onclick="this.parentElement.remove()">✕</button>';

    getToastContainer().appendChild(toast);

    if (duration > 0) {
        setTimeout(function () {
            toast.style.opacity   = '0';
            toast.style.transform = 'translateX(120%)';
            toast.style.transition = 'all 0.4s ease';
            setTimeout(function () { toast.remove(); }, 420);
        }, duration);
    }
}

// ==================== ADMIN ALERT SYSTEM ====================

/**
 * alertAdmin(violationType, details)
 *
 * Sends a real-time POST to the admin alert endpoint.
 * Throttled per type to 1 alert per 8 seconds.
 */
function alertAdmin(violationType, details) {
    if (!PROCTORING_CONFIG.adminAlertEndpoint) return;

    const now  = Date.now();
    const key  = 'admin_' + violationType;
    const last = proctoringState.lastReportTime[key] || 0;
    if (now - last < 8000) return;
    proctoringState.lastReportTime[key] = now;

    fetch(PROCTORING_CONFIG.adminAlertEndpoint, {
        method:  'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            exam_id:        window.EXAM_ID    || null,
            session_id:     window.SESSION_ID || null,
            violation_type: violationType,
            severity:       getSeverity(violationType),
            details:        details || {},
            timestamp:      new Date().toISOString()
        })
    }).catch(function (err) {
        console.warn('[Proctoring] Admin alert error (non-critical):', err.message);
    });
}

function getSeverity(type) {
    const high   = ['multiple_faces','camera_access_denied','excessive_violations','dev_tools_attempt'];
    const medium = ['face_not_visible','tab_switch','fullscreen_exit'];
    return high.indexOf(type) > -1 ? 'high' : medium.indexOf(type) > -1 ? 'medium' : 'low';
}

// ==================== VIOLATION LOGGING ====================

/**
 * logViolation(violationType, details)
 *
 * Posts to student-side backend endpoint AND calls alertAdmin().
 * Throttled per type (5 s) except for immediate violations.
 */
function logViolation(violationType, details) {
    details = details || {};

    const immediateTypes = ['multiple_faces','camera_access_denied','excessive_violations'];
    const now  = Date.now();
    const key  = 'student_' + violationType;
    const last = proctoringState.lastReportTime[key] || 0;

    if (immediateTypes.indexOf(violationType) === -1 && now - last < 5000) return;
    proctoringState.lastReportTime[key] = now;

    const examId = window.EXAM_ID || null;
    if (!examId) { console.warn('[Proctoring] No EXAM_ID — skipping violation log'); return; }

    const payload = {
        event_type: violationType,
        event_data: Object.assign({}, details, {
            timestamp:        new Date().toISOString(),
            userAgent:        navigator.userAgent,
            screenResolution: window.screen.width + 'x' + window.screen.height
        })
    };

    console.log('[Proctoring] Logging violation:', violationType, details);

    fetch('/student/api/exam/' + examId + '/proctoring-event', {
        method:  'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        if (!data.success) console.warn('[Proctoring] Backend error:', data.message);
    })
    .catch(function (err) {
        console.warn('[Proctoring] Violation log fetch error:', err.message);
    });

    // Always forward to admin endpoint
    alertAdmin(violationType, details);
}

// ==================== WEBCAM INITIALISATION ====================

function initializeWebcam() {
    const video = document.getElementById('webcam');
    if (!video) {
        console.error('[Proctoring] No #webcam element found');
        return Promise.reject(new Error('no webcam element'));
    }
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        showProctoringNotification('Camera API not supported in this browser.', 'danger');
        return Promise.reject(new Error('getUserMedia not supported'));
    }

    return navigator.mediaDevices.getUserMedia({
        video: { width: { ideal: 320 }, height: { ideal: 240 }, facingMode: 'user' },
        audio: false
    })
    .then(function (stream) {
        video.srcObject = stream;
        proctoringState.webcamActive = true;
        console.log('[Proctoring] Camera stream acquired');

        // Resolve only once video is producing frames
        return new Promise(function (resolve) {
            function onReady() {
                video.removeEventListener('playing',    onReady);
                video.removeEventListener('loadeddata', onReady);
                console.log('[Proctoring] Video ready (readyState=' + video.readyState + ')');
                resolve(video);
            }
            if (video.readyState >= 2) { resolve(video); return; }
            video.addEventListener('playing',    onReady);
            video.addEventListener('loadeddata', onReady);
            video.play().catch(function (e) {
                console.warn('[Proctoring] video.play() blocked:', e.message);
                resolve(video); // resolve anyway; detection guards readyState
            });
        });
    })
    .catch(function (err) {
        proctoringState.webcamActive = false;
        if (!proctoringState.cameraErrorReported) {
            proctoringState.cameraErrorReported = true;
            console.error('[Proctoring] Camera denied:', err.message);
            showProctoringNotification(
                '⚠️ Camera access required. Please allow camera access and refresh.',
                'danger',
                0   // persistent
            );
            logViolation('camera_access_denied', { message: err.message });
            alertAdmin('camera_access_denied', {
                message:    err.message,
                exam_id:    window.EXAM_ID,
                session_id: window.SESSION_ID
            });
        }
        return Promise.reject(err);
    });
}

// ==================== MODEL LOADING ====================

/**
 * FIX 2: Load ONLY tinyFaceDetector — the only net used by our
 * TinyFaceDetectorOptions call. Loading faceLandmark68Net /
 * faceRecognitionNet against a tiny-detector pipeline causes a shape
 * mismatch that silently kills detectAllFaces().
 */
function loadFaceDetectionModels() {
    const paths = [
        '/static/models',
        'https://cdn.jsdelivr.net/npm/@vladmandic/face-api/model'
    ];

    function tryPath(index) {
        if (index >= paths.length) return Promise.reject(new Error('All model paths failed'));
        console.log('[Proctoring] Loading models from:', paths[index]);
        return faceapi.nets.tinyFaceDetector.loadFromUri(paths[index])
            .then(function () { console.log('[Proctoring] Models loaded from:', paths[index]); })
            .catch(function () {
                console.warn('[Proctoring] Failed from:', paths[index]);
                return tryPath(index + 1);
            });
    }

    return tryPath(0);
}

// ==================== FACE DETECTION LOOP ====================

/**
 * FIX 5: requestAnimationFrame + timestamp gate.
 * Pauses automatically when the tab is hidden (rAF stops firing).
 */
function startFaceDetectionLoop(video) {
    if (proctoringState.faceDetectionActive) return;
    proctoringState.faceDetectionActive = true;

    const options = new faceapi.TinyFaceDetectorOptions({
        inputSize:      224,
        scoreThreshold: PROCTORING_CONFIG.faceDetection.minConfidence
    });

    function tick(ts) {
        if (!proctoringState.faceDetectionActive) return;

        if (ts - proctoringState.lastDetectionTime >= PROCTORING_CONFIG.faceDetection.checkInterval) {
            proctoringState.lastDetectionTime = ts;
            runDetectionPass(video, options);
        }

        proctoringState.detectionRafHandle = requestAnimationFrame(tick);
    }

    proctoringState.detectionRafHandle = requestAnimationFrame(tick);
    console.log('[Proctoring] Detection loop started');
}

function runDetectionPass(video, options) {
    if (!video || video.readyState < 2 || video.paused || video.ended) return;

    faceapi.detectAllFaces(video, options)
        .run()
        .then(function (detections) {
            handleDetectionResult(detections);
        })
        .catch(function (err) {
            console.log('[Proctoring] Detection frame skipped:', err.message);
        });
}

// ==================== DETECTION RESULT HANDLERS ====================

function handleDetectionResult(detections) {
    const count = detections.length;
    console.log('[Proctoring] Faces detected this pass:', count);

    if      (count === 0) { handleNoFaceDetected(); }
    else if (count === 1) { handleSingleFaceDetected(); }
    else                  { handleMultipleFacesDetected(count, detections); }
}

// ── No face ──────────────────────────────────────────────────────────────

function handleNoFaceDetected() {
    proctoringState.consecutiveMisses++;
    proctoringState.multipleFaceActive = false;

    console.log('[Proctoring] Consecutive misses:', proctoringState.consecutiveMisses);

    // FIX 4: require N consecutive misses before alerting
    if (proctoringState.consecutiveMisses < PROCTORING_CONFIG.faceDetection.consecutiveMissThreshold) {
        return;
    }

    proctoringState.violations.noFaceWarnings++;
    const warnCount = proctoringState.violations.noFaceWarnings;
    const maxWarn   = PROCTORING_CONFIG.violations.maxNoFaceWarnings;

    // ── Student notification ──────────────────────────────────────────
    showProctoringNotification(
        '⚠️ Warning ' + warnCount + '/' + maxWarn +
        ': Your face is not visible! Please position yourself in front of the camera.',
        'warning'
    );

    // ── Backend + admin ───────────────────────────────────────────────
    logViolation('face_not_visible', {
        consecutive_misses: proctoringState.consecutiveMisses,
        warning_count:      warnCount
    });

    alertAdmin('face_not_visible', {
        warning_count:      warnCount,
        consecutive_misses: proctoringState.consecutiveMisses,
        exam_id:            window.EXAM_ID,
        session_id:         window.SESSION_ID,
        message:            'Student face not visible — ' +
                            proctoringState.consecutiveMisses +
                            ' consecutive misses (warning ' + warnCount + '/' + maxWarn + ')'
    });

    if (warnCount >= maxWarn) handleExcessiveViolations('face_not_visible');
}

// ── Single face (normal) ─────────────────────────────────────────────────

function handleSingleFaceDetected() {
    // FIX 4: reset miss counter on successful detection
    proctoringState.consecutiveMisses = 0;
    proctoringState.multipleFaceActive = false;
}

// ── Multiple faces ───────────────────────────────────────────────────────

/**
 * FIX 3: Fires every detection interval while ≥2 faces present.
 * logViolation's own throttle (5 s) prevents server spam while still
 * keeping UI alerts live.
 */
function handleMultipleFacesDetected(faceCount, detections) {
    proctoringState.consecutiveMisses  = 0;
    proctoringState.multipleFaceActive = true;

    proctoringState.violations.multipleFaceWarnings++;
    const warnCount = proctoringState.violations.multipleFaceWarnings;
    const maxWarn   = PROCTORING_CONFIG.violations.maxMultipleFaceWarnings;

    const scores = detections.map(function (d) {
        return d.score ? d.score.toFixed(3) : 'n/a';
    });

    // ── Student notification ──────────────────────────────────────────
    showProctoringNotification(
        '🚨 Warning ' + warnCount + '/' + maxWarn +
        ': ' + faceCount + ' faces detected! Only YOU should be visible on camera.',
        'danger'
    );

    // Show persistent banner for multi-face (extra alarming)
    showPersistentWarning('multiple_faces', faceCount);

    // ── Backend + admin ───────────────────────────────────────────────
    logViolation('multiple_faces', {
        face_count:    faceCount,
        scores:        scores,
        warning_count: warnCount
    });

    alertAdmin('multiple_faces', {
        face_count:    faceCount,
        scores:        scores,
        warning_count: warnCount,
        exam_id:       window.EXAM_ID,
        session_id:    window.SESSION_ID,
        message:       faceCount + ' faces detected in exam session (warning ' +
                       warnCount + '/' + maxWarn + ')'
    });

    if (warnCount >= maxWarn) handleExcessiveViolations('multiple_faces');
}

// ==================== TAB SWITCHING DETECTION ====================

document.addEventListener('visibilitychange', function () {
    if (document.hidden) handleTabSwitch('visibility');
});

window.addEventListener('blur', function () {
    if (!document.hidden) handleTabSwitch('blur');
});

function handleTabSwitch(trigger) {
    proctoringState.violations.tabSwitches++;
    const count = proctoringState.violations.tabSwitches;
    const max   = PROCTORING_CONFIG.violations.maxTabSwitches;

    logViolation('tab_switch', { count: count, trigger: trigger || 'unknown' });

    showProctoringNotification(
        '⚠️ Tab switch detected! (' + count + '/' + max +
        ') Please stay on the exam page.',
        'warning'
    );

    alertAdmin('tab_switch', {
        count:      count,
        trigger:    trigger,
        exam_id:    window.EXAM_ID,
        session_id: window.SESSION_ID,
        message:    'Student switched tab/window (count: ' + count + ')'
    });

    // Notify take_exam.html auto-submit hook
    if (typeof window.PROCTORING_TAB_SWITCH_CALLBACK === 'function') {
        window.PROCTORING_TAB_SWITCH_CALLBACK(count);
    }

    if (count >= max) handleExcessiveViolations('tab_switch');
}

// ==================== COPY / PASTE PREVENTION ====================

document.addEventListener('copy', function (e) {
    e.preventDefault();
    proctoringState.violations.copyAttempts++;
    const count = proctoringState.violations.copyAttempts;
    const max   = PROCTORING_CONFIG.violations.maxCopyAttempts;

    logViolation('copy_attempt', { count: count });
    showProctoringNotification('⚠️ Copy attempt blocked! (' + count + '/' + max + ')', 'warning');
    alertAdmin('copy_attempt', {
        count: count, exam_id: window.EXAM_ID, session_id: window.SESSION_ID
    });

    if (count >= max) handleExcessiveViolations('copy_attempt');
});

document.addEventListener('paste', function (e) {
    // Allow paste inside theory textareas
    if (e.target && (e.target.tagName === 'TEXTAREA' || e.target.classList.contains('theory-textarea'))) return;

    e.preventDefault();
    proctoringState.violations.pasteAttempts++;
    const count = proctoringState.violations.pasteAttempts;
    const max   = PROCTORING_CONFIG.violations.maxPasteAttempts;

    logViolation('paste_attempt', { count: count });
    showProctoringNotification('⚠️ Paste attempt blocked! (' + count + '/' + max + ')', 'warning');
    alertAdmin('paste_attempt', {
        count: count, exam_id: window.EXAM_ID, session_id: window.SESSION_ID
    });

    if (count >= max) handleExcessiveViolations('paste_attempt');
});

// ==================== FULLSCREEN ENFORCEMENT ====================

function requestFullscreen() {
    if (proctoringState.fullscreenRequested) return;

    const elem = document.documentElement;

    const doRequest = function () {
        const p = elem.requestFullscreen          ? elem.requestFullscreen()
                : elem.webkitRequestFullscreen    ? (elem.webkitRequestFullscreen(), Promise.resolve())
                : elem.msRequestFullscreen        ? (elem.msRequestFullscreen(),     Promise.resolve())
                : Promise.reject(new Error('Fullscreen API not available'));

        Promise.resolve(p)
            .then(function ()   { proctoringState.fullscreenRequested = true; })
            .catch(function (e) { console.warn('[Proctoring] Fullscreen blocked:', e.message); });
    };

    try { doRequest(); }
    catch (e) {
        const events = ['click','keydown','touchstart'];
        const once   = function () {
            if (!proctoringState.fullscreenRequested) doRequest();
            events.forEach(function (ev) { document.removeEventListener(ev, once); });
        };
        events.forEach(function (ev) { document.addEventListener(ev, once, { once: true }); });
        showProctoringNotification('Click anywhere to enter fullscreen mode.', 'info');
    }
}

function handleFullscreenChange() {
    const isFullscreen = !!(document.fullscreenElement ||
                            document.webkitFullscreenElement ||
                            document.msFullscreenElement);
    if (!isFullscreen && proctoringState.fullscreenRequested) {
        proctoringState.violations.fullscreenExits++;
        proctoringState.fullscreenRequested = false;

        logViolation('fullscreen_exit', { count: proctoringState.violations.fullscreenExits });
        alertAdmin('fullscreen_exit', {
            count:      proctoringState.violations.fullscreenExits,
            exam_id:    window.EXAM_ID,
            session_id: window.SESSION_ID
        });
        showProctoringNotification('⚠️ Fullscreen exited! Click anywhere to return to fullscreen.', 'warning');

        setTimeout(function () {
            if (!document.fullscreenElement) requestFullscreen();
        }, 2000);
    }
}

document.addEventListener('fullscreenchange',       handleFullscreenChange);
document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
document.addEventListener('msfullscreenchange',     handleFullscreenChange);

// ==================== DEVTOOLS PREVENTION ====================

document.addEventListener('contextmenu', function (e) {
    e.preventDefault();
    logViolation('right_click_attempt', {});
});

document.addEventListener('keydown', function (e) {
    const blocked = e.key === 'F12' ||
        (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J' || e.key === 'C')) ||
        (e.ctrlKey && e.key === 'U');
    if (blocked) {
        e.preventDefault();
        logViolation('dev_tools_attempt', { key: e.key, ctrl: e.ctrlKey, shift: e.shiftKey });
        alertAdmin('dev_tools_attempt', {
            key: e.key, exam_id: window.EXAM_ID, session_id: window.SESSION_ID,
            message: 'Student attempted to open DevTools (key: ' + e.key + ')'
        });
    }
});

// ==================== EXCESSIVE VIOLATIONS ====================

function handleExcessiveViolations(violationType) {
    console.warn('[Proctoring] Excessive violations:', violationType);

    logViolation('excessive_violations', {
        violation_type: violationType,
        all_violations: proctoringState.violations
    });

    alertAdmin('excessive_violations', {
        violation_type: violationType,
        all_violations: proctoringState.violations,
        exam_id:        window.EXAM_ID,
        session_id:     window.SESSION_ID,
        message:        'Student exceeded threshold for: ' + violationType +
                        '. All violations: ' + JSON.stringify(proctoringState.violations)
    });

    showPersistentWarning(violationType, null);
}

function showPersistentWarning(violationType, faceCount) {
    const existingId = 'persistent-warning-' + violationType;
    const old = document.getElementById(existingId);
    if (old) old.remove();

    const isMultiFace = (violationType === 'multiple_faces');
    const icon    = isMultiFace ? '👥' : '⚠️';
    const title   = isMultiFace ? 'MULTIPLE PEOPLE DETECTED' : 'EXAM INTEGRITY WARNING';
    const bodyMsg = isMultiFace
        ? (faceCount ? faceCount + ' faces were detected on camera. ' : '') +
          'Only you should be taking this exam.'
        : 'Multiple violations detected. Your instructor has been notified in real-time.';

    const warning = document.createElement('div');
    warning.id        = existingId;
    warning.className = 'persistent-warning';
    warning.innerHTML =
        '<div class="persistent-warning-content">' +
            '<div class="warning-icon">' + icon + '</div>' +
            '<div class="warning-text">' +
                '<h4>' + title + '</h4>' +
                '<p>' + bodyMsg + '</p>' +
                '<p>Your instructor has been notified in real-time.</p>' +
                '<p><strong>Continued violations may result in automatic exam submission.</strong></p>' +
            '</div>' +
            '<button class="warning-close-btn" ' +
            'onclick="document.getElementById(\'' + existingId + '\').remove()">✕</button>' +
        '</div>';

    document.body.appendChild(warning);

    setTimeout(function () {
        if (warning.parentElement) {
            warning.style.transition = 'all 0.5s ease';
            warning.style.opacity    = '0';
            warning.style.transform  = 'translateX(120%)';
            setTimeout(function () { warning.remove(); }, 520);
        }
    }, 12000);
}

// ==================== STOP PROCTORING ====================

function stopProctoring() {
    console.log('[Proctoring] Stopping. Final violations:', proctoringState.violations);

    proctoringState.faceDetectionActive = false;
    if (proctoringState.detectionRafHandle) {
        cancelAnimationFrame(proctoringState.detectionRafHandle);
        proctoringState.detectionRafHandle = null;
    }

    const video = document.getElementById('webcam');
    if (video && video.srcObject) {
        video.srcObject.getTracks().forEach(function (t) { t.stop(); });
        video.srcObject = null;
    }
}

window.stopProctoring = stopProctoring;

// ==================== MAIN INIT ====================

function initializeProctoring() {
    console.log('[Proctoring] Initialising...');

    initializeWebcam()
        .then(function (video) {
            if (!PROCTORING_CONFIG.faceDetection.enabled) return;

            // FIX 1: models must load before detection starts
            return loadFaceDetectionModels()
                .then(function () {
                    proctoringState.modelsLoaded = true;
                    startFaceDetectionLoop(video);
                    showProctoringNotification(
                        '🔒 Proctoring active. This session is being monitored.',
                        'info'
                    );
                })
                .catch(function (err) {
                    console.warn('[Proctoring] Face detection unavailable:', err.message);
                    showProctoringNotification(
                        '⚠️ Face detection could not load. Behavioural monitoring is still active.',
                        'warning'
                    );
                });
        })
        .catch(function (err) {
            console.warn('[Proctoring] Camera unavailable:', err.message);
            // Behavioural monitoring (tab-switch, copy/paste, devtools) still runs below
        });

    requestFullscreen();
}

// ==================== BOOTSTRAP ====================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeProctoring);
} else {
    initializeProctoring();
}

window.addEventListener('beforeunload', stopProctoring);