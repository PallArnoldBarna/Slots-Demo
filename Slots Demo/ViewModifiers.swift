//
//  ViewModifiers.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 02.03.2026.
//

import Foundation
import SwiftUI

struct BetAmountStepperModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 180)
            .padding(.vertical, 13)
            .padding(.horizontal, 10)
            .background(.orange)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}

struct BetAmountPickerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 130)
            .foregroundColor(.white)
            .padding(10)
            .background(.orange)
            .cornerRadius(20)
    }
}

struct BetAmountPickerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(.menu)
            .tint(.white)
            .frame(height: 40)
    }
}

struct ButtonTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .padding(10)
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(.pink)
            .cornerRadius(20)
    }
}

struct StarImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.yellow)
    }
}

struct CreditsTextModifier: ViewModifier {
    var win: Bool
    var credits: Int
    
    init(_ win: Bool, _ credits: Int) {
        self.win = win
        self.credits = credits
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding(10)
            .background(win ? .green.opacity(0.5) : .white.opacity(0.5))
            .animation(.none, value: credits)
            .cornerRadius(20)
            .scaleEffect(win ? 1.2 : 1)
            .animation(.spring(response: 0.7, dampingFraction: 0.3), value: credits)
    }
}

struct TitleTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
}

struct RectangleModifier: ViewModifier {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    
    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(red: red/255, green: green/255, blue: blue/255))
            .edgesIgnoringSafeArea(.all)
    }
}

struct AutoplayToggleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(width: 145)
            .padding()
            .background(.blue)
            .cornerRadius(20)
    }
}
