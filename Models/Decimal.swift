//
//  Decimal.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import Foundation

struct FixedDecimal {
    static let SCALE: Int64 = 1_000_000 // 6 decimal places
    private var value: Int64
    
    init(_ value: Int64 = 0) {
        self.value = value * Self.SCALE
    }
    
    init(_ value: Double) {
        self.value = Int64((value * Double(Self.SCALE)).rounded())
    }
    
    init(_ string: String) {
        if let dotIndex = string.firstIndex(of: ".") {
            let wholePart = String(string[..<dotIndex])
            var fracPart = String(string[string.index(after: dotIndex)...])
            
            // Pad or truncate to 6 digits
            while fracPart.count < 6 { fracPart += "0" }
            if fracPart.count > 6 { fracPart = String(fracPart.prefix(6)) }
            
            let wholeValue = Int64(wholePart) ?? 0
            let fracValue = Int64(fracPart) ?? 0
            
            if string.hasPrefix("-") && wholeValue == 0 {
                self.value = -fracValue
            } else if wholeValue < 0 {
                self.value = wholeValue * Self.SCALE - fracValue
            } else {
                self.value = wholeValue * Self.SCALE + fracValue
            }
        } else {
            self.value = (Int64(string) ?? 0) * Self.SCALE
        }
    }
    
    static func fromScaled(_ scaled: Int64) -> FixedDecimal {
        var decimal = FixedDecimal(Int64(0))
        decimal.value = scaled
        return decimal
    }
    
    // Arithmetic operators
    static func +(lhs: FixedDecimal, rhs: FixedDecimal) -> FixedDecimal {
        return .fromScaled(lhs.value + rhs.value)
    }
    
    static func -(lhs: FixedDecimal, rhs: FixedDecimal) -> FixedDecimal {
        return .fromScaled(lhs.value - rhs.value)
    }
    
    static func *(lhs: FixedDecimal, rhs: FixedDecimal) -> FixedDecimal {
        let result = (lhs.value * rhs.value) / SCALE
        return .fromScaled(result)
    }
    
    static func /(lhs: FixedDecimal, rhs: FixedDecimal) -> FixedDecimal {
        guard rhs.value != 0 else { return .fromScaled(0) }
        let result = (lhs.value * SCALE) / rhs.value
        return .fromScaled(result)
    }
    
    var toString: String {
        if value == 0 { return "0" }
        
        let absValue = abs(value)
        let wholePart = absValue / Self.SCALE
        let fracPart = absValue % Self.SCALE
        
        var result = value < 0 ? "-" : ""
        result += String(wholePart)
        
        if fracPart != 0 {
            result += "."
            var fracStr = String(format: "%06d", fracPart)
            while fracStr.hasSuffix("0") {
                fracStr.removeLast()
            }
            result += fracStr
        }
        
        return result
    }
    
    var toDouble: Double {
        return Double(value) / Double(Self.SCALE)
    }
}
