//
//  KeypadView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI

struct KeypadView: View {
    @ObservedObject var calculator: CalculatorBrain
    
    let buttonTextColor: Color = Color("keyText")
    
    let buttonColors: [String: Color] = [
        "AC": Color("keyRed"),
        "Del": .orange,
        "=": Color("keyGreen"),
        "÷": Color("keyBlue"), "×": Color("keyBlue"), "-": Color("keyBlue"), "+": Color("keyBlue"),
        "MM": Color("keyPurple"), "round": Color("keyYellow"),
        "x/y": Color("keyOrange"), ">": .gray
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let buttonWidth = (geometry.size.width - 3) / 4 // 4 columns with 3 spacings
            let buttonHeight = (geometry.size.height - 5) / 6 // 6 rows with 5 spacings
            
            VStack(spacing: 1) {
                // Top row: Round, MM, x/y (3 buttons taking full width)
                HStack(spacing: 1) {
                    let topRowButtonWidth = (geometry.size.width - 2) / 3 // 3 columns with 2 spacings
                    
                    CalculatorButton(
                        title: "round",
                        color: buttonColor(for: "round"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("round") }
                    )
                    .frame(width: topRowButtonWidth, height: buttonHeight)
                    
                    CalculatorButton(
                        title: "MM",
                        color: buttonColor(for: "MM"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("MM") }
                    )
                    .frame(width: topRowButtonWidth, height: buttonHeight)
                    
                    CalculatorButton(
                        title: "x/y",
                        color: buttonColor(for: "x/y"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("x/y") }
                    )
                    .frame(width: topRowButtonWidth, height: buttonHeight)
                }
                
                // Second row: AC, ÷, ×, -
                HStack(spacing: 1) {
                    CalculatorButton(
                        title: "AC",
                        color: buttonColor(for: "AC"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("AC") }
                    )
                    .frame(width: buttonWidth, height: buttonHeight)
                    
                    CalculatorButton(
                        title: "÷",
                        color: buttonColor(for: "÷"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("÷") }
                    )
                    .frame(width: buttonWidth, height: buttonHeight)
                    
                    CalculatorButton(
                        title: "×",
                        color: buttonColor(for: "×"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("×") }
                    )
                    .frame(width: buttonWidth, height: buttonHeight)
                    
                    CalculatorButton(
                        title: "-",
                        color: buttonColor(for: "-"),
                        textColor: buttonTextColor,
                        action: { calculator.handleKey("-") }
                    )
                    .frame(width: buttonWidth, height: buttonHeight)
                }
                
                // Third and Fourth rows: with tall + button
                HStack(spacing: 1) {
                    VStack(spacing: 1) {
                        // Third row: 7, 8, 9
                        HStack(spacing: 1) {
                            CalculatorButton(
                                title: "7",
                                color: buttonColor(for: "7"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("7") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "8",
                                color: buttonColor(for: "8"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("8") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "9",
                                color: buttonColor(for: "9"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("9") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                        }
                        
                        // Fourth row: 4, 5, 6
                        HStack(spacing: 1) {
                            CalculatorButton(
                                title: "4",
                                color: buttonColor(for: "4"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("4") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "5",
                                color: buttonColor(for: "5"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("5") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "6",
                                color: buttonColor(for: "6"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("6") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                        }
                    }
                    
                    // Tall + button (spans 2 rows)
                    Button(action: { calculator.handleKey("+") }) {
                        Text("+")
                            .font(.system(size: 20))
                            .foregroundColor(buttonTextColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(buttonColor(for: "+").opacity(0.8))
                    }
                    .buttonStyle(CalculatorButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: buttonWidth, height: buttonHeight * 2 + 1)
                }
                
                // Fifth and Sixth rows: with tall = button
                HStack(spacing: 1) {
                    VStack(spacing: 1) {
                        // Fifth row: 1, 2, 3
                        HStack(spacing: 1) {
                            CalculatorButton(
                                title: "1",
                                color: buttonColor(for: "1"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("1") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "2",
                                color: buttonColor(for: "2"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("2") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                            
                            CalculatorButton(
                                title: "3",
                                color: buttonColor(for: "3"),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey("3") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                        }
                        
                        // Sixth row: wide 0, .
                        HStack(spacing: 1) {
                            // Wide 0 button (spans 2 columns)
                            Button(action: { calculator.handleKey("0") }) {
                                Text("0")
                                    .font(.system(size: 20))
                                    .foregroundColor(buttonTextColor)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(buttonColor(for: "0").opacity(0.8))
                            }
                            .buttonStyle(CalculatorButtonStyle())
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: buttonWidth * 2 + 1, height: buttonHeight)
                            
                            CalculatorButton(
                                title: ".",
                                color: buttonColor(for: "."),
                                textColor: buttonTextColor,
                                action: { calculator.handleKey(".") }
                            )
                            .frame(width: buttonWidth, height: buttonHeight)
                        }
                    }
                    
                    // Tall = button (spans 2 rows)
                    Button(action: { calculator.handleKey("=") }) {
                        Text("=")
                            .font(.system(size: 20))
                            .foregroundColor(buttonTextColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(buttonColor(for: "=").opacity(0.8))
                    }
                    .buttonStyle(CalculatorButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: buttonWidth, height: buttonHeight * 2 + 1)
                }
            }
        }
        .background(Color.gray.opacity(0.2))
    }
    
    func buttonColor(for button: String) -> Color {
        buttonColors[button] ?? Color("Keys")
    }
}

struct CalculatorButton: View {
    let title: String
    let color: Color
    let textColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color.opacity(0.8))
        }
        .buttonStyle(CalculatorButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    ContentView()
}
