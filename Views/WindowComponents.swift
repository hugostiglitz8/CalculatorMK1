//
//  WindowComponents.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI
import AppKit

// Custom Window Manager
class CustomWindowManager: NSObject {
    static func configureWindow(_ window: NSWindow) {
        // Remove title bar
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
        window.styleMask.remove(.titled)
        
        // Hide standard traffic light buttons
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Make window movable by background
        window.isMovableByWindowBackground = true
        
        // Set window level
        window.level = .normal
        window.acceptsMouseMovedEvents = true
        
        // Ensure window can become key (canBecomeKey is read-only, so we just make it key)
        window.makeKey()
    }
}

// Traffic Light Button Component
struct TrafficLightButton: View {
    let color: Color
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(isHovering ? color : Color.gray.opacity(0.5))
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
