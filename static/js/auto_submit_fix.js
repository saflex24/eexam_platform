// ═══════════════════════════════════════════════════════════════════════════
// CRITICAL FIX: AUTO-SUBMIT WITH ANSWER PRESERVATION
// This file MUST be loaded AFTER the main exam script
// ═══════════════════════════════════════════════════════════════════════════

(function() {
    'use strict';
    
    console.log('[AutoSubmitFix] Initializing answer preservation system...');
    
    // ══════════════════════════════════════════════════════════════════════════
    // OVERRIDE handleTimeExpired to save answers BEFORE submitting
    // ══════════════════════════════════════════════════════════════════════════
    
    const originalHandleTimeExpired = window.handleTimeExpired;
    
    window.handleTimeExpired = function() {
        console.log('[AutoSubmitFix] ⏰ Time expired! Starting answer preservation...');
        
        // Step 1: Stop all timers
        if (typeof timerInterval !== 'undefined') clearInterval(timerInterval);
        if (typeof autoSaveInterval !== 'undefined') clearInterval(autoSaveInterval);
        
        // Step 2: Remove beforeunload listener
        window.removeEventListener('beforeunload', preventUnload);
        
        // Step 3: CRITICAL - Save all current answers to form inputs
        const examForm = document.getElementById('examForm');
        if (!examForm) {
            console.error('[AutoSubmitFix] Form not found!');
            return;
        }
        
        // Step 4: Get all answers from localStorage
        const savedDataStr = localStorage.getItem(`exam_session_${sessionId}`);
        let answersRestored = 0;
        
        if (savedDataStr) {
            try {
                const savedData = JSON.parse(savedDataStr);
                console.log('[AutoSubmitFix] Found saved data with', Object.keys(savedData.answers || {}).length, 'answers');
                
                if (savedData.answers) {
                    // Restore each answer to the form
                    for (let [questionName, answerValue] of Object.entries(savedData.answers)) {
                        // For radio buttons (MCQ and True/False)
                        const radio = document.querySelector(`input[name="${questionName}"][value="${answerValue}"]`);
                        if (radio && radio.type === 'radio') {
                            radio.checked = true;
                            answersRestored++;
                            console.log(`[AutoSubmitFix] Restored radio: ${questionName} = ${answerValue}`);
                        }
                        
                        // For textareas (Theory questions)
                        const textarea = document.querySelector(`textarea[name="${questionName}"]`);
                        if (textarea) {
                            textarea.value = answerValue;
                            answersRestored++;
                            console.log(`[AutoSubmitFix] Restored textarea: ${questionName}`);
                        }
                    }
                }
            } catch (e) {
                console.error('[AutoSubmitFix] Error parsing saved data:', e);
            }
        } else {
            console.warn('[AutoSubmitFix] No saved data found in localStorage!');
        }
        
        console.log(`[AutoSubmitFix] ✅ Restored ${answersRestored} answers to form`);
        
        // Step 5: Add time_expired flag
        const addHiddenInput = (name, value) => {
            // Remove existing
            const existing = examForm.querySelector(`input[name="${name}"]`);
            if (existing) existing.remove();
            
            // Add new
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            examForm.appendChild(input);
        };
        
        addHiddenInput('time_expired', 'true');
        
        // Calculate time spent (if available)
        if (typeof timeLeft !== 'undefined') {
            const examDuration = {{ exam.duration_minutes }} * 60;
            const timeSpent = examDuration - timeLeft;
            addHiddenInput('time_spent', timeSpent);
            console.log(`[AutoSubmitFix] Time spent: ${timeSpent}s`);
        }
        
        // Step 6: Log form data for debugging
        const formData = new FormData(examForm);
        const formAnswers = [];
        for (let [key, value] of formData.entries()) {
            if (key.startsWith('question_')) {
                formAnswers.push(`${key}=${value}`);
            }
        }
        console.log(`[AutoSubmitFix] Form now contains ${formAnswers.length} question answers:`);
        console.log(formAnswers.join(', '));
        
        // Step 7: Show notification
        if (typeof showNotification === 'function') {
            showNotification('⏰ Time expired! Submitting your answers...', 'danger');
        }
        
        // Step 8: Wait a moment for UI update, then submit
        setTimeout(() => {
            console.log('[AutoSubmitFix] 📤 Submitting form...');
            examForm.submit();
        }, 1500);
    };
    
    // ══════════════════════════════════════════════════════════════════════════
    // ENHANCE saveAnswersToLocalStorage to be more aggressive
    // ══════════════════════════════════════════════════════════════════════════
    
    const originalSaveAnswers = window.saveAnswersToLocalStorage;
    
    window.saveAnswersToLocalStorage = function() {
        const examForm = document.getElementById('examForm');
        if (!examForm) return;
        
        const answers = {};
        
        // Method 1: Get from FormData
        const formData = new FormData(examForm);
        for (let [key, value] of formData.entries()) {
            if (key.startsWith('question_')) {
                answers[key] = value;
            }
        }
        
        // Method 2: Get from checked radio buttons (more reliable)
        const checkedRadios = document.querySelectorAll('input[type="radio"]:checked');
        checkedRadios.forEach(radio => {
            if (radio.name.startsWith('question_')) {
                answers[radio.name] = radio.value;
            }
        });
        
        // Method 3: Get from textareas
        const textareas = document.querySelectorAll('textarea[name^="question_"]');
        textareas.forEach(textarea => {
            if (textarea.value && textarea.value.trim()) {
                answers[textarea.name] = textarea.value;
            }
        });
        
        const saveData = {
            answers: answers,
            answeredQuestions: Array.from(answeredQuestions || []),
            flaggedQuestions: Array.from(flaggedQuestions || []),
            currentQuestion: currentQuestion || 1,
            timeLeft: typeof timeLeft !== 'undefined' ? timeLeft : 0,
            timestamp: new Date().toISOString()
        };
        
        try {
            localStorage.setItem(`exam_session_${sessionId}`, JSON.stringify(saveData));
            console.log(`[AutoSubmitFix] 💾 Saved ${Object.keys(answers).length} answers`);
            return true;
        } catch (e) {
            console.error('[AutoSubmitFix] Save failed:', e);
            return false;
        }
    };
    
    // ══════════════════════════════════════════════════════════════════════════
    // AUTO-SAVE on every answer change
    // ══════════════════════════════════════════════════════════════════════════
    
    function attachAutoSaveListeners() {
        // Save when radio buttons are clicked
        const radios = document.querySelectorAll('input[type="radio"]');
        radios.forEach(radio => {
            radio.addEventListener('change', () => {
                console.log('[AutoSubmitFix] Answer changed, auto-saving...');
                setTimeout(() => window.saveAnswersToLocalStorage(), 200);
            });
        });
        
        // Save when textareas are changed
        const textareas = document.querySelectorAll('textarea[name^="question_"]');
        textareas.forEach(textarea => {
            textarea.addEventListener('input', debounce(() => {
                console.log('[AutoSubmitFix] Textarea changed, auto-saving...');
                window.saveAnswersToLocalStorage();
            }, 1000));
            
            textarea.addEventListener('blur', () => {
                console.log('[AutoSubmitFix] Textarea blur, force saving...');
                window.saveAnswersToLocalStorage();
            });
        });
        
        console.log(`[AutoSubmitFix] ✅ Attached auto-save to ${radios.length} radios and ${textareas.length} textareas`);
    }
    
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // INITIALIZE
    // ══════════════════════════════════════════════════════════════════════════
    
    function initialize() {
        // Wait for DOM
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
        
        function init() {
            console.log('[AutoSubmitFix] Initializing...');
            
            // Attach listeners
            setTimeout(() => {
                attachAutoSaveListeners();
            }, 1000);
            
            // Save every 5 seconds
            setInterval(() => {
                window.saveAnswersToLocalStorage();
            }, 5000);
            
            // Save on page hide
            document.addEventListener('visibilitychange', () => {
                if (document.hidden) {
                    console.log('[AutoSubmitFix] Page hidden, force saving...');
                    window.saveAnswersToLocalStorage();
                }
            });
            
            // Save before page unload
            window.addEventListener('beforeunload', () => {
                console.log('[AutoSubmitFix] Page unloading, force saving...');
                window.saveAnswersToLocalStorage();
            });
            
            console.log('[AutoSubmitFix] ✅ Initialization complete');
        }
    }
    
    initialize();
    
    // ══════════════════════════════════════════════════════════════════════════
    // EXPOSE FOR DEBUGGING
    // ══════════════════════════════════════════════════════════════════════════
    
    window.AutoSubmitDebug = {
        forceSave: () => {
            window.saveAnswersToLocalStorage();
            console.log('Force save executed');
        },
        checkSaved: () => {
            const saved = localStorage.getItem(`exam_session_${sessionId}`);
            if (saved) {
                const data = JSON.parse(saved);
                console.log('Saved answers:', data.answers);
                console.log('Count:', Object.keys(data.answers || {}).length);
            } else {
                console.log('No saved data');
            }
        },
        simulateTimeExpire: () => {
            window.handleTimeExpired();
        }
    };
    
    console.log('[AutoSubmitFix] 🛡️ Answer preservation system active!');
    console.log('[AutoSubmitFix] Debug: AutoSubmitDebug.forceSave() / .checkSaved() / .simulateTimeExpire()');
    
})();