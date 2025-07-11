//
//  ContentView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var calculator = CalculatorBrain()
    
    var body: some View {
        VStack(spacing: 0) {
            DisplayView(calculator: calculator)
            KeypadView(calculator: calculator)
        }
        .frame(width: 320, height: 500)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                handleKeyEvent(event)
                return nil
            }
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        guard let characters = event.characters else { return }
        
        switch characters {
        case "0"..."9", ".":
            calculator.handleKey(characters)
        case "+", "-", "*", "/":
            // Convert keyboard operators to display operators
            let displayOp = characters == "*" ? "×" : characters == "/" ? "÷" : characters
            calculator.handleKey(displayOp)
        case "\r", "\n": // Enter/Return key
            calculator.handleKey("=")
        case "\u{7F}": // Delete key
            calculator.handleKey("Del")
        case "\u{1B}": // Escape key
            calculator.handleKey("AC")
        case " ":
            calculator.handleKey(">")
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}
