//
//  CalculatorBrain.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import Foundation

class CalculatorBrain: ObservableObject {
    @Published var displayValue = ""
    @Published var historyValue = ""
    @Published var alternateValue = ""
    @Published var lastAnswer = ""
    
    private var currentExpression = ""
    private var justCalculated = false
    private var usedFractionEntry = false
    
    func handleKey(_ key: String) {
        switch key {
        case "AC":
            clear()
        case "Del":
            if !justCalculated && !currentExpression.isEmpty {
                currentExpression.removeLast()
                displayValue = currentExpression
            }
        case "=":
            calculate()
        case "x/y":
            if !currentExpression.isEmpty && !currentExpression.hasSuffix("/") && !currentExpression.hasSuffix(" ") {
                currentExpression += "/"
                displayValue = currentExpression
                usedFractionEntry = true
            }
        case ">":
            if !currentExpression.isEmpty && !currentExpression.hasSuffix(" ") {
                currentExpression += " "
                displayValue = currentExpression
            }
        case "round":
            toggleFractionDecimal()
        case "MM":
            convertUnits()
        case "+", "-", "×", "÷":
            handleOperator(key)
        default:
            if justCalculated {
                if "0"..."9" ~= key || key == "." {
                    currentExpression = key
                    justCalculated = false
                    usedFractionEntry = false
                } else {
                    return
                }
            } else {
                currentExpression += key
            }
            displayValue = currentExpression
        }
    }
    
    private func clear() {
        displayValue = ""
        historyValue = ""
        alternateValue = ""
        currentExpression = ""
        justCalculated = false
        usedFractionEntry = false
    }
    
    private func calculate() {
        guard !currentExpression.isEmpty && !justCalculated else { return }
        
        historyValue = currentExpression
        let result = evaluateExpression(currentExpression)
        lastAnswer = result.toString
        
        if usedFractionEntry {
            let fraction = Fraction.decimalToSixtyFourths(result.toDouble)
            displayValue = fraction.mixedFractionString
            alternateValue = result.toString
        } else {
            displayValue = result.toString
            let fraction = Fraction.decimalToSixtyFourths(result.toDouble)
            alternateValue = fraction.mixedFractionString
        }
        
        currentExpression = displayValue
        justCalculated = true
        usedFractionEntry = false
    }
    
    private func handleOperator(_ op: String) {
        if justCalculated {
            currentExpression = displayValue + op
            justCalculated = false
        } else if !currentExpression.isEmpty {
            currentExpression += op
        }
        displayValue = currentExpression
    }
    
    private func toggleFractionDecimal() {
        guard !displayValue.isEmpty else { return }
        
        if displayValue.contains("/") || displayValue.contains(" ") {
            let decimal = evaluateExpression(displayValue)
            displayValue = decimal.toString
            lastAnswer = decimal.toString
        } else {
            let decimal = evaluateExpression(displayValue)
            let fraction = Fraction.decimalToSixtyFourths(decimal.toDouble)
            displayValue = fraction.mixedFractionString
            lastAnswer = decimal.toString
        }
        
        currentExpression = displayValue
        justCalculated = true
    }
    
    private func convertUnits() {
        guard !displayValue.isEmpty else { return }
        
        let value = evaluateExpression(displayValue)
        // For now, simple mm to inches conversion
        let inches = value.toDouble / 25.4
        displayValue = FixedDecimal(inches).toString + " in"
        lastAnswer = FixedDecimal(inches).toString
        
        currentExpression = displayValue
        justCalculated = true
    }
    
    private func evaluateExpression(_ expr: String) -> FixedDecimal {
        var expression = expr
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        // Simple expression evaluator
        var result = FixedDecimal(Int64(0))
        var currentOp: Character = "+"
        var currentToken = ""
        
        for char in expression + "+" {
            if "+-*/".contains(char) && !currentToken.isEmpty {
                let value = parseMixedFraction(currentToken)
                
                switch currentOp {
                case "+": result = result + value
                case "-": result = result - value
                case "*": result = result * value
                case "/": result = result / value
                default: break
                }
                
                currentToken = ""
                currentOp = char
            } else if char != " " || !currentToken.isEmpty {
                currentToken.append(char)
            }
        }
        
        return result
    }
    
    private func parseMixedFraction(_ token: String) -> FixedDecimal {
        let trimmed = token.trimmingCharacters(in: .whitespaces)
        
        if let spaceIndex = trimmed.firstIndex(of: " ") {
            // Mixed number
            let wholePart = String(trimmed[..<spaceIndex])
            let fracPart = String(trimmed[trimmed.index(after: spaceIndex)...])
            
            let whole = FixedDecimal(wholePart)
            if let slashIndex = fracPart.firstIndex(of: "/") {
                let num = String(fracPart[..<slashIndex])
                let den = String(fracPart[fracPart.index(after: slashIndex)...])
                
                let fraction = FixedDecimal(num) / FixedDecimal(den)
                return whole + fraction
            }
            return whole
        } else if let slashIndex = trimmed.firstIndex(of: "/") {
            // Simple fraction
            let num = String(trimmed[..<slashIndex])
            let den = String(trimmed[trimmed.index(after: slashIndex)...])
            return FixedDecimal(num) / FixedDecimal(den)
        } else {
            // Regular number
            return FixedDecimal(trimmed)
        }
    }
}
