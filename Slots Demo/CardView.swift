//
//  CardView.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 24.02.2026.
//

import SwiftUI

struct CardView: View {
    @Binding var symbol: String
    @Binding var background: Color
    private let transition: AnyTransition = AnyTransition.asymmetric(
        insertion: .move(edge: .top),
        removal: .move(edge: .bottom)
    )
    
    var body: some View {
        Image(symbol)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .transition(transition)
            .id(symbol)
            .background(background.opacity(0.5))
            .cornerRadius(20)
    }
}

#Preview {
    CardView(symbol: Binding.constant("apple"), background: Binding.constant(.green))
}
