//
//  ContentView.swift
//  CalculatorMK1
//
//  Created by Kevin Kiley on 7/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = CalculatorBrain()
    
    var body: some View {
        VStack(spacing: 0) {
            DisplayView(calculator: calculator)
            KeypadView(calculator: calculator)
        }
        .frame(width: 320, height: 500)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}
    .onAppear {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            handleKeyEvent(event)
            return nil
        }
    }
