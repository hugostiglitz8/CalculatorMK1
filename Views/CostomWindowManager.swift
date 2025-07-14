import SwiftUI
import AppKit

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
        
        // Ensure window can become key
        window.canBecomeKey = true
        window.makeKey()
    }
}

// Custom traffic light buttons view
struct TrafficLightButtons: View {
    @State private var isHovering = false
    @Environment(\.controlActiveState) private var controlActiveState
    
    var body: some View {
        HStack(spacing: 8) {
            TrafficLightButton(color: .red, action: closeWindow)
            TrafficLightButton(color: .yellow, action: minimizeWindow)
            TrafficLightButton(color: .green, action: zoomWindow)
        }
        .padding(.leading, 12)
        .padding(.vertical, 4)
        .opacity(isHovering ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
    
    private func closeWindow() {
        NSApplication.shared.keyWindow?.close()
    }
    
    private func minimizeWindow() {
        NSApplication.shared.keyWindow?.miniaturize(nil)
    }
    
    private func zoomWindow() {
        NSApplication.shared.keyWindow?.zoom(nil)
    }
}

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

// Custom menu bar that slides down on hover
struct SlidingMenuBar: View {
    @State private var isHovering = false
    @State private var isMenuBarVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Hover detection area
            Color.clear
                .frame(height: 30)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isHovering = hovering
                        isMenuBarVisible = hovering
                    }
                }
            
            // Menu bar content
            if isMenuBarVisible {
                HStack {
                    TrafficLightButtons()
                    
                    Spacer()
                    
                    // App title or other menu items
                    Text("Calculator MK1")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                }
                .frame(height: 28)
                .background(Color.black.opacity(0.8))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
