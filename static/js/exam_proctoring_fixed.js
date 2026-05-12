/**
 * FIXED: Advanced Exam Proctoring System with Face Detection
 * Changes:
 * - Removed confirm() dialogs that freeze the page
 * - Uses non-blocking notifications instead
 * - Better user experience during violations
 * - FIXED: Fullscreen only requests on user gesture
 * - ADDED: Auto-submit callback integration
 */

// ==================== CONFIGURATION ====================
const PROCTORING_CONFIG = {
    faceDetection: {
        enabled: true,
        checkInterval: 3000,        // Check every 3 seconds
        noFaceThreshold: 5000,      // Alert after 5 seconds no face
        multipleFaceThreshold: 3000, // Alert after 3 seconds multiple faces
        minConfidence: 0.5           // Minimum face detection confidence
    },
    violations: {
        maxTabSwitches: 10,
        maxCopyAttempts: 5,
        maxPasteAttempts: 5,
        maxNoFaceWarnings: 5,
        maxMultipleFaceWarnings: 5
    }
};

// ==================== STATE MANAGEMENT ====================
let proctoringState = {
    webcamActive: false,
    faceDetectionActive: false,
    faceLastSeen: Date.now(),
    multipleFaceDetected: false,
    fullscreenRequested: false,  // Track if we already asked for fullscreen
    violations: {
        tabSwitches: 0,
        copyAttempts: 0,
        pasteAttempts: 0,
        noFaceWarnings: 0,
        multipleFaceWarnings: 0,
        fullscreenExits: 0
    },
    timers: {
        faceCheck: null,
        noFaceAlert: null,
        multipleFaceAlert: null
    }
};

// ==================== WEBCAM AND FACE DETECTION ====================

/**
 * Initialize webcam stream
 */
async function initializeWebcam() {
    try {
        const video = document.getElementById('webcam');
        if (!video) {
            console.error('Webcam element not found');
            return false;
        }

        const stream = await navigator.mediaDevices.getUserMedia({
            video: {
                width: { ideal: 640 },
                height: { ideal: 480 },
                facingMode: 'user'
            },
            audio: false
        });

        video.srcObject = stream;
        proctoringState.webcamActive = true;
        
        console.log('✅ Webcam initialized successfully');
        return true;
    } catch (error) {
        console.error('❌ Webcam initialization failed:', error);
        showNotification('Camera access is required for this exam. Please allow camera access.', 'danger');
        logViolation('camera_access_denied', { error: error.message });
        return false;
    }
}

/**
 * Load face-api.js models
 */
async function loadFaceDetectionModels() {
    try {
        const MODEL_URL = 'https://cdn.jsdelivr.net/npm/@vladmandic/face-api/model';
        
        await Promise.all([
            faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
            faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
            faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL)
        ]);
        
        console.log('✅ Face detection models loaded');
        return true;
    } catch (error) {
        console.error('❌ Failed to load face detection models:', error);
        return false;
    }
}

/**
 * Start face detection monitoring
 */
async function startFaceDetection() {
    if (!PROCTORING_CONFIG.faceDetection.enabled) {
        console.log('Face detection is disabled');
        return;
    }

    const video = document.getElementById('webcam');
    if (!video || !proctoringState.webcamActive) {
        console.error('Webcam not ready for face detection');
        return;
    }

    // Wait for video to be ready
    await new Promise(resolve => {
        if (video.readyState >= 2) {
            resolve();
        } else {
            video.onloadeddata = () => resolve();
        }
    });

    console.log('🎥 Starting face detection...');
    proctoringState.faceDetectionActive = true;
    
    // Start periodic face checking
    proctoringState.timers.faceCheck = setInterval(checkForFaces, PROCTORING_CONFIG.faceDetection.checkInterval);
}

/**
 * Check for faces in webcam feed
 */
async function checkForFaces() {
    if (!proctoringState.faceDetectionActive) return;

    const video = document.getElementById('webcam');
    if (!video || video.paused) return;

    try {
        const detections = await faceapi.detectAllFaces(
            video,
            new faceapi.TinyFaceDetectorOptions({
                inputSize: 320,
                scoreThreshold: PROCTORING_CONFIG.faceDetection.minConfidence
            })
        );

        const faceCount = detections.length;
        
        if (faceCount === 0) {
            handleNoFaceDetected();
        } else if (faceCount === 1) {
            handleSingleFaceDetected();
        } else if (faceCount > 1) {
            handleMultipleFacesDetected(faceCount);
        }

    } catch (error) {
        console.error('Face detection error:', error);
    }
}

/**
 * Handle case when no face is detected
 */
function handleNoFaceDetected() {
    const timeSinceLastFace = Date.now() - proctoringState.faceLastSeen;
    
    if (timeSinceLastFace > PROCTORING_CONFIG.faceDetection.noFaceThreshold) {
        // Face has been missing for too long
        if (!proctoringState.timers.noFaceAlert) {
            proctoringState.timers.noFaceAlert = setTimeout(() => {
                proctoringState.violations.noFaceWarnings++;
                
                logViolation('face_not_visible', {
                    duration: timeSinceLastFace,
                    warningCount: proctoringState.violations.noFaceWarnings
                });
                
                showNotification(
                    `⚠️ Warning ${proctoringState.violations.noFaceWarnings}/${PROCTORING_CONFIG.violations.maxNoFaceWarnings}: Face not visible! Please position yourself in front of the camera.`,
                    'warning'
                );
                
                // Check if exceeded max warnings
                if (proctoringState.violations.noFaceWarnings >= PROCTORING_CONFIG.violations.maxNoFaceWarnings) {
                    handleExcessiveViolations('face_not_visible');
                }
            }, 1000);
        }
    }
}

/**
 * Handle case when single face is detected (normal)
 */
function handleSingleFaceDetected() {
    proctoringState.faceLastSeen = Date.now();
    proctoringState.multipleFaceDetected = false;
    
    // Clear any pending alerts
    if (proctoringState.timers.noFaceAlert) {
        clearTimeout(proctoringState.timers.noFaceAlert);
        proctoringState.timers.noFaceAlert = null;
    }
    if (proctoringState.timers.multipleFaceAlert) {
        clearTimeout(proctoringState.timers.multipleFaceAlert);
        proctoringState.timers.multipleFaceAlert = null;
    }
}

/**
 * Handle case when multiple faces are detected
 */
function handleMultipleFacesDetected(faceCount) {
    if (!proctoringState.multipleFaceDetected) {
        proctoringState.multipleFaceDetected = true;
        
        if (!proctoringState.timers.multipleFaceAlert) {
            proctoringState.timers.multipleFaceAlert = setTimeout(() => {
                proctoringState.violations.multipleFaceWarnings++;
                
                logViolation('multiple_faces', {
                    faceCount: faceCount,
                    warningCount: proctoringState.violations.multipleFaceWarnings
                });
                
                showNotification(
                    `⚠️ Warning ${proctoringState.violations.multipleFaceWarnings}/${PROCTORING_CONFIG.violations.maxMultipleFaceWarnings}: Multiple faces detected! Only one person should be taking this exam.`,
                    'warning'
                );
                
                // Check if exceeded max warnings
                if (proctoringState.violations.multipleFaceWarnings >= PROCTORING_CONFIG.violations.maxMultipleFaceWarnings) {
                    handleExcessiveViolations('multiple_faces');
                }
            }, PROCTORING_CONFIG.faceDetection.multipleFaceThreshold);
        }
    }
}

// ==================== VIOLATION LOGGING ====================

/**
 * Log violation to backend
 */
function logViolation(violationType, details = {}) {
    const violationData = {
        event_type: violationType,
        event_data: {
            ...details,
            timestamp: new Date().toISOString(),
            userAgent: navigator.userAgent,
            screenResolution: `${window.screen.width}x${window.screen.height}`
        }
    };

    console.log('📝 Logging violation:', violationType, details);

    // Send to backend
    fetch(`/student/api/exam/${window.EXAM_ID}/proctoring-event`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || ''
        },
        body: JSON.stringify(violationData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log('✅ Violation logged successfully');
        } else {
            console.error('❌ Failed to log violation:', data.message);
        }
    })
    .catch(error => {
        console.error('❌ Error logging violation:', error);
    });
}

// ==================== TAB SWITCHING DETECTION ====================

/**
 * Handle tab switching / focus loss
 */
function handleTabSwitch() {
    proctoringState.violations.tabSwitches++;
    
    logViolation('tab_switch', {
        count: proctoringState.violations.tabSwitches,
        timestamp: new Date().toISOString()
    });
    
    showNotification(
        `⚠️ Tab switch detected! (${proctoringState.violations.tabSwitches}/${PROCTORING_CONFIG.violations.maxTabSwitches}) Please stay on the exam tab.`,
        'warning'
    );
    
    // ── AUTO-SUBMIT CALLBACK ─────────────────────────────────
    // Call the auto-submit system if it's registered
    if (typeof window.PROCTORING_TAB_SWITCH_CALLBACK === 'function') {
        window.PROCTORING_TAB_SWITCH_CALLBACK(proctoringState.violations.tabSwitches);
    }
    // ──────────────────────────────────────────────────────────
    
    if (proctoringState.violations.tabSwitches >= PROCTORING_CONFIG.violations.maxTabSwitches) {
        handleExcessiveViolations('tab_switch');
    }
}

// Listen for visibility change
document.addEventListener('visibilitychange', function() {
    if (document.hidden) {
        handleTabSwitch();
    }
});

// ==================== COPY/PASTE PREVENTION ====================

/**
 * Prevent copy attempts
 */
document.addEventListener('copy', function(e) {
    e.preventDefault();
    proctoringState.violations.copyAttempts++;
    
    logViolation('copy_attempt', {
        count: proctoringState.violations.copyAttempts
    });
    
    showNotification(
        `⚠️ Copy attempt detected! (${proctoringState.violations.copyAttempts}/${PROCTORING_CONFIG.violations.maxCopyAttempts})`,
        'warning'
    );
    
    if (proctoringState.violations.copyAttempts >= PROCTORING_CONFIG.violations.maxCopyAttempts) {
        handleExcessiveViolations('copy_attempt');
    }
});

/**
 * Prevent paste attempts
 */
document.addEventListener('paste', function(e) {
    // Allow paste in theory answer textareas
    if (e.target.classList.contains('theory-textarea') || 
        e.target.id === 'theoryAnswer' ||
        e.target.tagName === 'TEXTAREA') {
        return; // Allow paste for theory questions
    }
    
    e.preventDefault();
    proctoringState.violations.pasteAttempts++;
    
    logViolation('paste_attempt', {
        count: proctoringState.violations.pasteAttempts
    });
    
    showNotification(
        `⚠️ Paste attempt detected! (${proctoringState.violations.pasteAttempts}/${PROCTORING_CONFIG.violations.maxPasteAttempts})`,
        'warning'
    );
    
    if (proctoringState.violations.pasteAttempts >= PROCTORING_CONFIG.violations.maxPasteAttempts) {
        handleExcessiveViolations('paste_attempt');
    }
});

// ==================== FULLSCREEN ENFORCEMENT ====================

/**
 * Request fullscreen mode — FIXED: Only on user gesture
 */
function requestFullscreen() {
    if (proctoringState.fullscreenRequested) {
        console.log('Fullscreen already requested, skipping');
        return;
    }

    const elem = document.documentElement;
    
    const doRequest = () => {
        if (elem.requestFullscreen) {
            elem.requestFullscreen().then(() => {
                proctoringState.fullscreenRequested = true;
                console.log('✅ Fullscreen activated');
            }).catch(err => {
                console.warn('Fullscreen request failed:', err.message);
                // Don't spam — just log once
            });
        } else if (elem.webkitRequestFullscreen) {
            elem.webkitRequestFullscreen();
            proctoringState.fullscreenRequested = true;
        } else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
            proctoringState.fullscreenRequested = true;
        }
    };

    // ── METHOD 1: Try immediately (works if already had a gesture) ──
    try {
        doRequest();
    } catch (err) {
        console.log('Direct fullscreen failed, waiting for user gesture...');
        
        // ── METHOD 2: Wait for any user interaction ──
        const gestureTriggers = ['click', 'keydown', 'touchstart'];
        const oneTimeFullscreen = () => {
            if (!proctoringState.fullscreenRequested) {
                doRequest();
            }
            // Remove listeners after first attempt
            gestureTriggers.forEach(ev => document.removeEventListener(ev, oneTimeFullscreen));
        };
        gestureTriggers.forEach(ev => document.addEventListener(ev, oneTimeFullscreen, { once: true }));
        
        // Show hint to user
        showNotification('Click anywhere on the page to enter fullscreen mode.', 'info');
    }
}

/**
 * Handle fullscreen change
 */
function handleFullscreenChange() {
    if (!document.fullscreenElement && 
        !document.webkitFullscreenElement && 
        !document.msFullscreenElement) {
        
        // Only log if we had already entered fullscreen
        if (proctoringState.fullscreenRequested) {
            proctoringState.violations.fullscreenExits++;
            
            logViolation('fullscreen_exit', {
                count: proctoringState.violations.fullscreenExits
            });
            
            showNotification('⚠️ Fullscreen mode exited! Click anywhere to return to fullscreen.', 'warning');
            
            // Reset flag so we can request again
            proctoringState.fullscreenRequested = false;
            
            // Attempt to re-enter fullscreen after 2 seconds (requires gesture)
            setTimeout(() => {
                if (!document.fullscreenElement) {
                    requestFullscreen();
                }
            }, 2000);
        }
    }
}

document.addEventListener('fullscreenchange', handleFullscreenChange);
document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
document.addEventListener('msfullscreenchange', handleFullscreenChange);

// ==================== EXCESSIVE VIOLATIONS HANDLING ====================

/**
 * Handle excessive violations - FIXED: No more freezing confirm dialogs
 */
function handleExcessiveViolations(violationType) {
    console.warn('🚨 EXCESSIVE VIOLATIONS:', violationType);
    
    logViolation('excessive_violations', {
        violationType: violationType,
        allViolations: proctoringState.violations
    });
    
    // Show persistent warning notification instead of confirm dialog
    showPersistentWarning(violationType);
}

/**
 * Show persistent warning notification (doesn't freeze the page)
 */
function showPersistentWarning(violationType) {
    // Remove any existing persistent warnings
    const existingWarning = document.getElementById('persistent-violation-warning');
    if (existingWarning) {
        existingWarning.remove();
    }
    
    const warning = document.createElement('div');
    warning.id = 'persistent-violation-warning';
    warning.className = 'persistent-warning';
    warning.innerHTML = `
        <div class="persistent-warning-content">
            <div class="warning-icon">⚠️</div>
            <div class="warning-text">
                <h4>EXAM INTEGRITY WARNING</h4>
                <p>Multiple violations have been detected during this exam.</p>
                <p>Your instructor has been notified.</p>
                <p><strong>Continued violations may result in automatic exam submission.</strong></p>
            </div>
            <button class="warning-close-btn" onclick="this.parentElement.parentElement.remove()">
                ✕
            </button>
        </div>
    `;
    
    document.body.appendChild(warning);
    
    // Auto-remove after 10 seconds
    setTimeout(() => {
        if (warning && warning.parentElement) {
            warning.style.animation = 'slideOutRight 0.5s ease';
            setTimeout(() => warning.remove(), 500);
        }
    }, 10000);
}

// Add CSS for persistent warning and notifications
const warningStyle = document.createElement('style');
warningStyle.textContent = `
    .persistent-warning {
        position: fixed;
        top: 80px;
        right: 20px;
        z-index: 10001;
        max-width: 450px;
        animation: slideInRight 0.5s ease;
    }
    
    .persistent-warning-content {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        border: 3px solid #ef4444;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 10px 40px rgba(239, 68, 68, 0.4);
        position: relative;
    }
    
    .warning-icon {
        font-size: 48px;
        text-align: center;
        margin-bottom: 10px;
        animation: pulse 1s infinite;
    }
    
    .warning-text h4 {
        color: #991b1b;
        margin: 0 0 10px 0;
        font-size: 18px;
        font-weight: 700;
        text-align: center;
    }
    
    .warning-text p {
        color: #7f1d1d;
        margin: 5px 0;
        font-size: 14px;
        text-align: center;
    }
    
    .warning-close-btn {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #ef4444;
        color: white;
        border: none;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: all 0.3s;
    }
    
    .warning-close-btn:hover {
        background: #dc2626;
        transform: scale(1.1);
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(500px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(500px);
            opacity: 0;
        }
    }
    
    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.1); }
    }
    
    .exam-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 10000;
        min-width: 300px;
        max-width: 500px;
        animation: slideInRight 0.5s ease;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
`;
document.head.appendChild(warningStyle);

// ==================== INITIALIZATION ====================

/**
 * Initialize proctoring system
 */
async function initializeProctoring() {
    console.log('🔒 Initializing proctoring system...');
    
    try {
        // 1. Initialize webcam
        const webcamReady = await initializeWebcam();
        if (!webcamReady) {
            console.error('Cannot proceed without webcam');
            showNotification('Camera access is required to take this exam.', 'danger');
            return false;
        }
        
        // 2. Load face detection models
        if (PROCTORING_CONFIG.faceDetection.enabled) {
            const modelsLoaded = await loadFaceDetectionModels();
            if (!modelsLoaded) {
                console.warn('Face detection models failed to load - continuing without face detection');
                PROCTORING_CONFIG.faceDetection.enabled = false;
            }
        }
        
        // 3. Start face detection
        if (PROCTORING_CONFIG.faceDetection.enabled) {
            await startFaceDetection();
        }
        
        // 4. Request fullscreen (will wait for user gesture if needed)
        requestFullscreen();
        
        // 5. Prevent right-click
        document.addEventListener('contextmenu', function(e) {
            e.preventDefault();
            logViolation('right_click_attempt', {});
        });
        
        // 6. Prevent keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Prevent F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U
            if (e.key === 'F12' || 
                (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J')) ||
                (e.ctrlKey && e.key === 'U')) {
                e.preventDefault();
                logViolation('dev_tools_attempt', {
                    key: e.key,
                    ctrlKey: e.ctrlKey,
                    shiftKey: e.shiftKey
                });
            }
        });
        
        console.log('✅ Proctoring system initialized successfully');
        showNotification('Proctoring active. Your exam session is being monitored for integrity.', 'info');
        
        return true;
        
    } catch (error) {
        console.error('❌ Proctoring initialization failed:', error);
        showNotification('Failed to initialize proctoring system.', 'danger');
        return false;
    }
}

/**
 * Stop proctoring system
 */
function stopProctoring() {
    console.log('🛑 Stopping proctoring system...');
    
    // Stop face detection
    proctoringState.faceDetectionActive = false;
    if (proctoringState.timers.faceCheck) {
        clearInterval(proctoringState.timers.faceCheck);
    }
    if (proctoringState.timers.noFaceAlert) {
        clearTimeout(proctoringState.timers.noFaceAlert);
    }
    if (proctoringState.timers.multipleFaceAlert) {
        clearTimeout(proctoringState.timers.multipleFaceAlert);
    }
    
    // Stop webcam
    const video = document.getElementById('webcam');
    if (video && video.srcObject) {
        video.srcObject.getTracks().forEach(track => track.stop());
    }
    
    console.log('✅ Proctoring system stopped');
}

// ==================== UTILITY FUNCTIONS ====================

/**
 * Show notification to user
 */
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} exam-notification`;
    notification.innerHTML = `
        <strong>${message}</strong>
        <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.5s ease';
        setTimeout(() => notification.remove(), 500);
    }, 5000);
}

// ==================== AUTO-START ON PAGE LOAD ====================

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeProctoring);
} else {
    initializeProctoring();
}

// Cleanup on page unload
window.addEventListener('beforeunload', function() {
    stopProctoring();
});