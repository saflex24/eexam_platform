// ═══════════════════════════════════════════════════════════════════════════
// SCIENTIFIC CALCULATOR FOR EXAM PAGE
// Features: Basic operations, trigonometry, logarithms, memory, history
// ═══════════════════════════════════════════════════════════════════════════

(function() {
    'use strict';
    
    // Calculator state
    const calculator = {
        display: '0',
        previousValue: null,
        operation: null,
        waitingForOperand: false,
        memory: 0,
        history: [],
        angleMode: 'DEG', // DEG or RAD
        isMinimized: false,
        position: { x: 0, y: 0 }
    };
    
    // ══════════════════════════════════════════════════════════════════════════
    // CALCULATOR FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function clearDisplay() {
        calculator.display = '0';
        calculator.previousValue = null;
        calculator.operation = null;
        calculator.waitingForOperand = false;
        updateDisplay();
    }
    
    function clearEntry() {
        calculator.display = '0';
        calculator.waitingForOperand = false;
        updateDisplay();
    }
    
    function inputDigit(digit) {
        if (calculator.waitingForOperand) {
            calculator.display = String(digit);
            calculator.waitingForOperand = false;
        } else {
            calculator.display = calculator.display === '0' ? String(digit) : calculator.display + digit;
        }
        updateDisplay();
    }
    
    function inputDecimal() {
        if (calculator.waitingForOperand) {
            calculator.display = '0.';
            calculator.waitingForOperand = false;
        } else if (calculator.display.indexOf('.') === -1) {
            calculator.display += '.';
        }
        updateDisplay();
    }
    
    function inputPercent() {
        const value = parseFloat(calculator.display);
        calculator.display = String(value / 100);
        updateDisplay();
    }
    
    function toggleSign() {
        const value = parseFloat(calculator.display);
        calculator.display = String(value * -1);
        updateDisplay();
    }
    
    function performOperation(nextOperation) {
        const inputValue = parseFloat(calculator.display);
        
        if (calculator.previousValue === null) {
            calculator.previousValue = inputValue;
        } else if (calculator.operation) {
            const currentValue = calculator.previousValue || 0;
            const newValue = performCalculation(currentValue, inputValue, calculator.operation);
            
            calculator.display = String(newValue);
            calculator.previousValue = newValue;
            
            addToHistory(`${currentValue} ${calculator.operation} ${inputValue} = ${newValue}`);
        }
        
        calculator.waitingForOperand = true;
        calculator.operation = nextOperation;
        updateDisplay();
    }
    
    function performCalculation(firstValue, secondValue, operation) {
        switch (operation) {
            case '+': return firstValue + secondValue;
            case '-': return firstValue - secondValue;
            case '×': return firstValue * secondValue;
            case '÷': return firstValue / secondValue;
            case '^': return Math.pow(firstValue, secondValue);
            case 'mod': return firstValue % secondValue;
            default: return secondValue;
        }
    }
    
    function calculateEquals() {
        const inputValue = parseFloat(calculator.display);
        
        if (calculator.operation && calculator.previousValue !== null) {
            const result = performCalculation(calculator.previousValue, inputValue, calculator.operation);
            calculator.display = String(result);
            addToHistory(`${calculator.previousValue} ${calculator.operation} ${inputValue} = ${result}`);
            calculator.previousValue = null;
            calculator.operation = null;
            calculator.waitingForOperand = true;
        }
        
        updateDisplay();
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // SCIENTIFIC FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }
    
    function toDegrees(radians) {
        return radians * (180 / Math.PI);
    }
    
    function scientificFunction(func) {
        let value = parseFloat(calculator.display);
        let result;
        
        switch (func) {
            case 'sin':
                result = calculator.angleMode === 'DEG' ? Math.sin(toRadians(value)) : Math.sin(value);
                addToHistory(`sin(${value}${calculator.angleMode === 'DEG' ? '°' : 'rad'}) = ${result}`);
                break;
            case 'cos':
                result = calculator.angleMode === 'DEG' ? Math.cos(toRadians(value)) : Math.cos(value);
                addToHistory(`cos(${value}${calculator.angleMode === 'DEG' ? '°' : 'rad'}) = ${result}`);
                break;
            case 'tan':
                result = calculator.angleMode === 'DEG' ? Math.tan(toRadians(value)) : Math.tan(value);
                addToHistory(`tan(${value}${calculator.angleMode === 'DEG' ? '°' : 'rad'}) = ${result}`);
                break;
            case 'asin':
                result = calculator.angleMode === 'DEG' ? toDegrees(Math.asin(value)) : Math.asin(value);
                addToHistory(`asin(${value}) = ${result}${calculator.angleMode === 'DEG' ? '°' : 'rad'}`);
                break;
            case 'acos':
                result = calculator.angleMode === 'DEG' ? toDegrees(Math.acos(value)) : Math.acos(value);
                addToHistory(`acos(${value}) = ${result}${calculator.angleMode === 'DEG' ? '°' : 'rad'}`);
                break;
            case 'atan':
                result = calculator.angleMode === 'DEG' ? toDegrees(Math.atan(value)) : Math.atan(value);
                addToHistory(`atan(${value}) = ${result}${calculator.angleMode === 'DEG' ? '°' : 'rad'}`);
                break;
            case 'sqrt':
                result = Math.sqrt(value);
                addToHistory(`√${value} = ${result}`);
                break;
            case 'cbrt':
                result = Math.cbrt(value);
                addToHistory(`∛${value} = ${result}`);
                break;
            case 'square':
                result = value * value;
                addToHistory(`${value}² = ${result}`);
                break;
            case 'cube':
                result = value * value * value;
                addToHistory(`${value}³ = ${result}`);
                break;
            case 'ln':
                result = Math.log(value);
                addToHistory(`ln(${value}) = ${result}`);
                break;
            case 'log':
                result = Math.log10(value);
                addToHistory(`log(${value}) = ${result}`);
                break;
            case 'exp':
                result = Math.exp(value);
                addToHistory(`e^${value} = ${result}`);
                break;
            case '10^x':
                result = Math.pow(10, value);
                addToHistory(`10^${value} = ${result}`);
                break;
            case 'reciprocal':
                result = 1 / value;
                addToHistory(`1/${value} = ${result}`);
                break;
            case 'factorial':
                result = factorial(Math.floor(value));
                addToHistory(`${Math.floor(value)}! = ${result}`);
                break;
            case 'abs':
                result = Math.abs(value);
                addToHistory(`|${value}| = ${result}`);
                break;
            case 'pi':
                result = Math.PI;
                addToHistory(`π = ${result}`);
                break;
            case 'e':
                result = Math.E;
                addToHistory(`e = ${result}`);
                break;
            default:
                result = value;
        }
        
        calculator.display = String(result);
        calculator.waitingForOperand = true;
        updateDisplay();
    }
    
    function factorial(n) {
        if (n < 0) return NaN;
        if (n === 0 || n === 1) return 1;
        if (n > 170) return Infinity; // Prevent overflow
        let result = 1;
        for (let i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // MEMORY FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function memoryClear() {
        calculator.memory = 0;
        updateMemoryIndicator();
        console.log('Memory cleared');
    }
    
    function memoryRecall() {
        calculator.display = String(calculator.memory);
        calculator.waitingForOperand = true;
        updateDisplay();
        console.log('Memory recalled:', calculator.memory);
    }
    
    function memoryAdd() {
        calculator.memory += parseFloat(calculator.display);
        updateMemoryIndicator();
        console.log('Memory add:', calculator.memory);
    }
    
    function memorySubtract() {
        calculator.memory -= parseFloat(calculator.display);
        updateMemoryIndicator();
        console.log('Memory subtract:', calculator.memory);
    }
    
    function memoryStore() {
        calculator.memory = parseFloat(calculator.display);
        updateMemoryIndicator();
        console.log('Memory stored:', calculator.memory);
    }
    
    function updateMemoryIndicator() {
        const indicator = document.getElementById('calc-memory-indicator');
        if (indicator) {
            indicator.style.display = calculator.memory !== 0 ? 'inline-block' : 'none';
        }
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // HISTORY FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function addToHistory(entry) {
        calculator.history.unshift(entry);
        if (calculator.history.length > 50) {
            calculator.history.pop();
        }
        updateHistoryDisplay();
    }
    
    function updateHistoryDisplay() {
        const historyDiv = document.getElementById('calc-history');
        if (!historyDiv) return;
        
        if (calculator.history.length === 0) {
            historyDiv.innerHTML = '<div style="color: #999; font-size: 12px; padding: 10px;">No history yet</div>';
        } else {
            historyDiv.innerHTML = calculator.history
                .slice(0, 10)
                .map(entry => `<div class="calc-history-item">${entry}</div>`)
                .join('');
        }
    }
    
    function clearHistory() {
        calculator.history = [];
        updateHistoryDisplay();
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // DISPLAY FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function updateDisplay() {
        const display = document.getElementById('calc-display');
        if (display) {
            // Format number for display
            let displayValue = calculator.display;
            
            // Handle very large or very small numbers
            const numValue = parseFloat(displayValue);
            if (!isNaN(numValue)) {
                if (Math.abs(numValue) > 1e10 || (Math.abs(numValue) < 1e-6 && numValue !== 0)) {
                    displayValue = numValue.toExponential(6);
                } else if (displayValue.length > 12) {
                    displayValue = parseFloat(displayValue).toPrecision(10);
                }
            }
            
            display.textContent = displayValue;
        }
        
        // Update angle mode indicator
        const angleBtn = document.getElementById('calc-angle-mode');
        if (angleBtn) {
            angleBtn.textContent = calculator.angleMode;
        }
    }
    
    function toggleAngleMode() {
        calculator.angleMode = calculator.angleMode === 'DEG' ? 'RAD' : 'DEG';
        updateDisplay();
        console.log('Angle mode:', calculator.angleMode);
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // UI FUNCTIONS
    // ══════════════════════════════════════════════════════════════════════════
    
    function toggleCalculator() {
        const calcContainer = document.getElementById('calculator-container');
        if (calcContainer) {
            if (calcContainer.classList.contains('calc-hidden')) {
                calcContainer.classList.remove('calc-hidden');
            } else {
                calcContainer.classList.add('calc-hidden');
            }
        }
    }
    
    function minimizeCalculator() {
        const calcContainer = document.getElementById('calculator-container');
        if (calcContainer) {
            calculator.isMinimized = !calculator.isMinimized;
            calcContainer.classList.toggle('calc-minimized');
            
            const minimizeBtn = document.querySelector('.calc-minimize-btn i');
            if (minimizeBtn) {
                minimizeBtn.className = calculator.isMinimized ? 'fas fa-plus' : 'fas fa-minus';
            }
        }
    }
    
    function toggleHistory() {
        const historyPanel = document.getElementById('calc-history-panel');
        if (historyPanel) {
            historyPanel.classList.toggle('show');
        }
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // KEYBOARD SUPPORT
    // ══════════════════════════════════════════════════════════════════════════
    
    function handleKeyboard(event) {
        // Only handle keyboard when calculator is visible and not minimized
        const calcContainer = document.getElementById('calculator-container');
        if (!calcContainer || calcContainer.classList.contains('calc-hidden') || calculator.isMinimized) {
            return;
        }
        
        const key = event.key;
        
        // Prevent default for calculator keys
        if (/[0-9\+\-\*\/\.\=\%]/.test(key) || key === 'Enter' || key === 'Escape' || key === 'Backspace') {
            // Only prevent if calculator is focused
            if (document.activeElement === document.body || 
                document.activeElement.closest('#calculator-container')) {
                event.preventDefault();
            }
        }
        
        // Number keys
        if (/[0-9]/.test(key)) {
            inputDigit(parseInt(key));
        }
        // Decimal point
        else if (key === '.') {
            inputDecimal();
        }
        // Operations
        else if (key === '+') {
            performOperation('+');
        }
        else if (key === '-') {
            performOperation('-');
        }
        else if (key === '*') {
            performOperation('×');
        }
        else if (key === '/') {
            performOperation('÷');
        }
        else if (key === '%') {
            inputPercent();
        }
        // Equals
        else if (key === '=' || key === 'Enter') {
            calculateEquals();
        }
        // Clear
        else if (key === 'Escape') {
            clearDisplay();
        }
        // Backspace
        else if (key === 'Backspace') {
            if (calculator.display.length > 1) {
                calculator.display = calculator.display.slice(0, -1);
            } else {
                calculator.display = '0';
            }
            updateDisplay();
        }
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // INITIALIZATION
    // ══════════════════════════════════════════════════════════════════════════
    
    function initCalculator() {
        console.log('Initializing scientific calculator...');
        
        // Make functions globally accessible
        window.calcClear = clearDisplay;
        window.calcClearEntry = clearEntry;
        window.calcInputDigit = inputDigit;
        window.calcInputDecimal = inputDecimal;
        window.calcInputPercent = inputPercent;
        window.calcToggleSign = toggleSign;
        window.calcPerformOperation = performOperation;
        window.calcEquals = calculateEquals;
        window.calcScientific = scientificFunction;
        window.calcMemoryClear = memoryClear;
        window.calcMemoryRecall = memoryRecall;
        window.calcMemoryAdd = memoryAdd;
        window.calcMemorySubtract = memorySubtract;
        window.calcMemoryStore = memoryStore;
        window.calcToggleAngleMode = toggleAngleMode;
        window.calcToggle = toggleCalculator;
        window.calcMinimize = minimizeCalculator;
        window.calcToggleHistory = toggleHistory;
        window.calcClearHistory = clearHistory;
        
        // Initialize display
        updateDisplay();
        updateMemoryIndicator();
        updateHistoryDisplay();
        
        // Keyboard support
        document.addEventListener('keydown', handleKeyboard);
        
        // Load saved position
        loadPosition();
        
        console.log('✓ Calculator initialized');
    }
    
    // ══════════════════════════════════════════════════════════════════════════
    // DRAGGABLE FUNCTIONALITY
    // ══════════════════════════════════════════════════════════════════════════
    
    function initDraggable() {
        const container = document.getElementById('calculator-container');
        const header = document.getElementById('calculator-header');
        
        if (!container || !header) return;
        
        let isDragging = false;
        let currentX, currentY, initialX, initialY;
        let xOffset = 0, yOffset = 0;
        
        header.addEventListener('mousedown', dragStart);
        document.addEventListener('mousemove', drag);
        document.addEventListener('mouseup', dragEnd);
        
        function dragStart(e) {
            if (e.target.closest('.calc-minimize-btn') || e.target.closest('.calc-close-btn')) {
                return;
            }
            
            initialX = e.clientX - xOffset;
            initialY = e.clientY - yOffset;
            
            if (e.target === header || header.contains(e.target)) {
                isDragging = true;
                container.classList.add('calc-dragging');
            }
        }
        
        function drag(e) {
            if (isDragging) {
                e.preventDefault();
                currentX = e.clientX - initialX;
                currentY = e.clientY - initialY;
                xOffset = currentX;
                yOffset = currentY;
                
                const rect = container.getBoundingClientRect();
                const maxX = window.innerWidth - rect.width;
                const maxY = window.innerHeight - rect.height;
                
                xOffset = Math.max(0, Math.min(xOffset, maxX));
                yOffset = Math.max(0, Math.min(yOffset, maxY));
                
                setTranslate(xOffset, yOffset);
            }
        }
        
        function dragEnd() {
            initialX = currentX;
            initialY = currentY;
            isDragging = false;
            container.classList.remove('calc-dragging');
            savePosition();
        }
        
        function setTranslate(xPos, yPos) {
            container.style.transform = `translate3d(${xPos}px, ${yPos}px, 0)`;
            calculator.position = { x: xPos, y: yPos };
        }
    }
    
    function savePosition() {
        try {
            localStorage.setItem('calculator_position', JSON.stringify(calculator.position));
        } catch (e) {
            console.error('Failed to save calculator position:', e);
        }
    }
    
    function loadPosition() {
        try {
            const saved = localStorage.getItem('calculator_position');
            if (saved) {
                const pos = JSON.parse(saved);
                const container = document.getElementById('calculator-container');
                if (container) {
                    container.style.transform = `translate3d(${pos.x}px, ${pos.y}px, 0)`;
                    calculator.position = pos;
                }
            }
        } catch (e) {
            console.error('Failed to load calculator position:', e);
        }
    }
    
    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            initCalculator();
            initDraggable();
        });
    } else {
        initCalculator();
        initDraggable();
    }
    
})();