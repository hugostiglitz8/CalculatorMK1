//
//  DisplayView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI

struct DisplayView: View {
    @ObservedObject var calculator: CalculatorBrain
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            // History line
            Text(calculator.historyValue)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Alternate display
            Text(calculator.alternateValue)
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Main display
            Text(calculator.displayValue.isEmpty ? "0" : calculator.displayValue)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .frame(height: 120)
        .background(Color.black)
    }
}
