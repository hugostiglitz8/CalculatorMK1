//
//  ContentView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI
import AppKit

// Helper class to handle window button actions
class WindowController: NSObject {
    var toggleMiniMode: (() -> Void)?
    
    @objc func handleZoomButton() {
        toggleMiniMode?()
    }
}

struct ContentView: View {
    @StateObject private var calculator = CalculatorBrain()
    @State private var isMiniMode = false
    @State private var windowController = WindowController()
    
    var body: some View {
        VStack(spacing: 0) {
            // Toggle button - always visible
            HStack {
                Button(action: toggleMiniMode) {
                    Image(systemName: isMiniMode ? "plus.rectangle" : "minus.rectangle")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 8)
                .padding(.top, 4)
                Spacer()
            }
            .frame(height: 20)
            
            DisplayView(calculator: calculator, isMiniMode: isMiniMode)
            
            if !isMiniMode {
                KeypadView(calculator: calculator)
            }
        }
        .frame(width: 320, height: isMiniMode ? 140 : 520) // Adjusted heights to account for button
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .onAppear {
            setupWindowControls()
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                handleKeyEvent(event)
                return nil
            }
        }
    }
    
    private func setupWindowControls() {
        windowController.toggleMiniMode = toggleMiniMode
        
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                // Override the green button (zoom button) action
                window.standardWindowButton(.zoomButton)?.target = windowController
                window.standardWindowButton(.zoomButton)?.action = #selector(WindowController.handleZoomButton)
            }
        }
    }
    
    private func toggleMiniMode() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isMiniMode.toggle()
        }
        
        // Update window size after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let window = NSApplication.shared.windows.first {
                let newSize = NSSize(width: 320, height: isMiniMode ? 140 : 520)
                window.setContentSize(newSize)
            }
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        // Only handle keyboard input in full mode
        guard !isMiniMode else { return }
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
