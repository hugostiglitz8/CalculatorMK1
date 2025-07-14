//
//  KeyboardHandler.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI
import AppKit

class KeyboardHandler: ObservableObject {
    private var monitor: Any?
    weak var calculator: CalculatorBrain?
    
    init() {
        setupKeyboardMonitoring()
    }
    
    deinit {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    private func setupKeyboardMonitoring() {
        // Use local monitor and consume events we handle
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if let self = self, self.handleKeyEvent(event) {
                return nil // Consume the event completely
            }
            return event // Let system handle it
        }
    }
    
    func setCalculator(_ calculator: CalculatorBrain) {
        self.calculator = calculator
    }
    
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        guard let calculator = calculator else { return false }
        guard let characters = event.characters else { return false }
        
        switch characters {
        case "0"..."9", ".":
            calculator.handleKey(characters)
            return true
        case "+", "-", "*", "/":
            let displayOp = characters == "*" ? "×" : characters == "/" ? "÷" : characters
            calculator.handleKey(displayOp)
            return true
        case "\r", "\n": // Enter/Return key
            calculator.handleKey("=")
            return true
        case "\u{7F}", "\u{8}": // Delete/Backspace key
            calculator.handleKey("Del")
            return true
        case "\u{1B}": // Escape key
            calculator.handleKey("AC")
            return true
        case " ":
            calculator.handleKey(">")
            return true
        default:
            return false
        }
    }
}
