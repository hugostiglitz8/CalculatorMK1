//
//  Fraction.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import Foundation

struct Fraction {
    var numerator: Int
    var denominator: Int
    
    init(numerator: Int = 0, denominator: Int = 1) {
        self.numerator = numerator
        self.denominator = denominator == 0 ? 1 : denominator
        simplify()
    }
    
    mutating func simplify() {
        if denominator < 0 {
            numerator = -numerator
            denominator = -denominator
        }
        let g = gcd(abs(numerator), abs(denominator))
        numerator /= g
        denominator /= g
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            let t = b
            b = a % b
            a = t
        }
        return a
    }
    
    var toDecimal: Double {
        return Double(numerator) / Double(denominator)
    }
    
    static func decimalToSixtyFourths(_ value: Double) -> Fraction {
        let n = Int((value * 64).rounded())
        return Fraction(numerator: n, denominator: 64)
    }
    
    var mixedFractionString: String {
        let n = abs(numerator)
        let whole = n / denominator
        let remainder = n % denominator
        
        var result = numerator < 0 ? "-" : ""
        
        if whole > 0 {
            result += String(whole)
            if remainder > 0 {
                result += " "
            }
        }
        
        if remainder > 0 {
            result += "\(remainder)/\(denominator)"
        }
        
        if whole == 0 && remainder == 0 {
            result = "0"
        }
        
        return result
    }
}
