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
    @State private var showKeypad = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                // Toggle button for mini mode - moved to top right
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showKeypad.toggle()
                    }
                }) {
                    Image(systemName: showKeypad ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)
                .padding(.top, 4)
            }
            
            DisplayView(calculator: calculator, isMiniMode: !showKeypad)
            
            if showKeypad {
                KeypadView(calculator: calculator)
            }
        }
        .frame(width: 320, height: showKeypad ? 540 : 100)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .focusable()
        .onAppear {
            setupKeyboardHandling()
            
            // Ensure window accepts key events
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    window.makeKey()
                    window.acceptsMouseMovedEvents = true
                    window.level = .normal
                }
            }
        }
        .onTapGesture {
            // Ensure focus when clicked
            if let window = NSApplication.shared.windows.first {
                window.makeKey()
            }
        }
    }
    
    private func setupKeyboardHandling() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if handleKeyEvent(event) {
                return nil // Consume the event
            }
            return event // Let system handle it
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
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

#Preview {
    ContentView()
}
