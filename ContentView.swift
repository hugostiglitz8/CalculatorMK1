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
    @State private var isMenuBarVisible = false
    @State private var isHoveringTop = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main calculator content
            VStack(spacing: 0) {
                // Invisible hover area at the top
                Color.clear
                    .frame(height: 40)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isHoveringTop = hovering
                            isMenuBarVisible = hovering
                        }
                    }
                
                // Calculator content with adjusted spacing
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        // Toggle button for mini mode
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
            }
            .frame(width: 320, height: showKeypad ? 580 : 140)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Sliding menu bar overlay
            if isMenuBarVisible {
                VStack(spacing: 0) {
                    HStack {
                        // Traffic light buttons
                        HStack(spacing: 8) {
                            TrafficLightButton(
                                color: Color(NSColor.systemRed),
                                action: { NSApplication.shared.keyWindow?.close() }
                            )
                            TrafficLightButton(
                                color: Color(NSColor.systemYellow),
                                action: { NSApplication.shared.keyWindow?.miniaturize(nil) }
                            )
                            TrafficLightButton(
                                color: Color(NSColor.systemGreen),
                                action: { NSApplication.shared.keyWindow?.zoom(nil) }
                            )
                        }
                        .padding(.leading, 12)
                        
                        Spacer()
                        
                        // App title
                        Text("Calculator MK1")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                    }
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.9))
                            .mask(
                                VStack(spacing: 0) {
                                    Rectangle()
                                    Color.clear.frame(height: 8)
                                }
                            )
                    )
                    
                    Spacer()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .focusable()
        .onAppear {
            setupKeyboardHandling()
            
            // Configure window appearance
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    CustomWindowManager.configureWindow(window)
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
