//
//  KeypadView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI

struct KeypadView: View {
    @ObservedObject var calculator: CalculatorBrain
    
    let buttons: [[String]] = [
        ["AC", "x/y", ">", "÷", "Del"],
        ["7", "8", "9", "×", "MM"],
        ["4", "5", "6", "-", "round"],
        ["1", "2", "3", "+", "="],
        ["0", "0", ".", "+", "="]
    ]
    
    let buttonColors: [String: Color] = [
        "AC": .red,
        "Del": .orange,
        "=": .green,
        "÷": .blue, "×": .blue, "-": .blue, "+": .blue,
        "MM": .purple, "round": .purple,
        "x/y": .gray, ">": .gray
    ]
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<5) { row in
                HStack(spacing: 1) {
                    ForEach(0..<5) { col in
                        CalculatorButton(
                            title: buttons[row][col],
                            color: buttonColor(for: buttons[row][col]),
                            action: {
                                calculator.handleKey(buttons[row][col])
                            }
                        )
                    }
                }
            }
        }
        .padding(1)
        .background(Color.gray.opacity(0.2))
    }
    
    func buttonColor(for button: String) -> Color {
        buttonColors[button] ?? .gray
    }
}

struct CalculatorButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color.opacity(0.8))
        }
        .buttonStyle(CalculatorButtonStyle())
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
