//
//  ViewExtensions.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 02.03.2026.
//

import Foundation
import SwiftUI

extension Stepper {
    func betAmountStepperStyle() -> some View {
        modifier(BetAmountStepperModifier())
    }
}

extension Picker {
    func betAmountPickerStyle() -> some View {
        modifier(BetAmountPickerStyle())
    }
}

extension HStack {
    func betAmountPickerModifier() -> some View {
        modifier(BetAmountPickerModifier())
    }
}

extension Toggle {
    func autoplayToggleStyle() -> some View {
        modifier(AutoplayToggleModifier())
    }
}

extension View {
    func rectangleStyle(red: CGFloat, green: CGFloat, blue: CGFloat) -> some View {
        modifier(RectangleModifier(red, green, blue))
    }
}

extension Text {
    func buttonTextStyle() -> some View {
        modifier(ButtonTextModifier())
    }
    
    func creditsTextStyle(win: Bool, credits: Int) -> some View {
        modifier(CreditsTextModifier(win, credits))
    }
    
    func titleTextModifier() -> some View {
        modifier(TitleTextModifier())
    }
}

extension Image {
    func starImageStyle() -> some View {
        modifier(StarImageModifier())
    }
}
