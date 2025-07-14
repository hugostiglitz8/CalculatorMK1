//
//  DisplayView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI

struct DisplayView: View {
    @ObservedObject var calculator: CalculatorBrain
    var isMiniMode: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: isMiniMode ? 2 : 5) {
            // History line - hide in mini mode if space is tight
            if !isMiniMode || !calculator.historyValue.isEmpty {
                Text(calculator.historyValue)
                    .font(.system(size: isMiniMode ? 10 : 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Alternate display - hide in mini mode to save space
            if !isMiniMode {
                Text(calculator.alternateValue)
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Main display
            Text(calculator.displayValue.isEmpty ? "0" : calculator.displayValue)
                .font(.system(size: isMiniMode ? 20 : 28, weight: .light))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(isMiniMode ? 8 : 16)
        .frame(height: isMiniMode ? 60 : 120)
        .background(Color.black)
    }
}
