//
//  ContentView.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 24.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .rectangleStyle(red: 200, green: 143, blue: 32)
                
            Rectangle()
                .rotationEffect(Angle(degrees: 45))
                .rectangleStyle(red: 228, green: 195, blue: 76)
                
            
            VStack {
                Spacer()
                
                HStack {
                    Image(systemName: Symbols.starSystem.rawValue)
                        .starImageStyle()
                    
                    Text(Strings.titleText.rawValue)
                        .titleTextModifier()
                    
                    Image(systemName: Symbols.starSystem.rawValue)
                        .starImageStyle()
                }
                .scaleEffect(2)
                
                Spacer()
                
                Text("\(Strings.creditsText.rawValue) \(String(gameViewModel.credits))")
                    .creditsTextStyle(win: gameViewModel.win, credits: gameViewModel.credits)
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[0][0]], background: $gameViewModel.backgrounds[0][0])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[0][1]], background: $gameViewModel.backgrounds[0][1])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[0][2]], background: $gameViewModel.backgrounds[0][2])
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[1][0]], background: $gameViewModel.backgrounds[1][0])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[1][1]], background: $gameViewModel.backgrounds[1][1])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[1][2]], background: $gameViewModel.backgrounds[1][2])
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[2][0]], background: $gameViewModel.backgrounds[2][0])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[2][1]], background: $gameViewModel.backgrounds[2][1])
                        
                        CardView(symbol: $gameViewModel.symbols[gameViewModel.numbers[2][2]], background: $gameViewModel.backgrounds[2][2])
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        Button(action: {
                            
                            withAnimation(.easeOut) {
                                gameViewModel.spinningProcess(onlyForMiddleRow: true)
                            }
                            
                        }, label: {
                            Text(Strings.spinOnlyMiddleRowButtonText.rawValue)
                                .buttonTextStyle()
                        }).disabled(gameViewModel.isOneRowButtonDisabled)
                        
                        Text("\(Strings.betText.rawValue) \(gameViewModel.betAmount)")
                        
                        Toggle(Strings.autoSpinText.rawValue, isOn: $gameViewModel.autoSpinOneRow)
                            .autoplayToggleStyle()
                            .onChange(of: gameViewModel.autoSpinOneRow) {
                                gameViewModel.autoSpinning(isOn: gameViewModel.autoSpinOneRow, onlyForMiddleRow: true)
                            }
                            
                    }
                    
                    VStack {
                        Button(action: {
                            
                            withAnimation(.easeOut) {
                                gameViewModel.spinningProcess(onlyForMiddleRow: false)
                            }
                            
                        }, label: {
                            Text(Strings.spinButtonText.rawValue)
                                .buttonTextStyle()
                        }).disabled(gameViewModel.isButtonDisabled)
                        
                        Text("\(Strings.betText.rawValue) \(gameViewModel.betAmount * 5)")
                        
                        Toggle(Strings.autoSpinText.rawValue, isOn: $gameViewModel.autoSpin)
                            .autoplayToggleStyle()
                            .onChange(of: gameViewModel.autoSpin) {
                                gameViewModel.autoSpinning(isOn: gameViewModel.autoSpin, onlyForMiddleRow: false)
                            }
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    HStack {
                        Text(Strings.betAmountText.rawValue)
                        
                        Spacer()
                        
                        Picker(Strings.betAmountText.rawValue, selection: $gameViewModel.betAmount) {
                            ForEach(gameViewModel.betOptions, id: \.self) { amount in
                                Text("\(amount)").tag(amount)
                            }
                        }
                        .betAmountPickerStyle()
                        .onChange(of: gameViewModel.betAmount) {
                            gameViewModel.betAmountIndex = gameViewModel.betOptions.firstIndex(of: gameViewModel.betAmount) ?? 0
                            gameViewModel.isOneRowButtonDisabled = gameViewModel.credits < gameViewModel.betAmount
                            gameViewModel.isButtonDisabled = gameViewModel.credits < (gameViewModel.betAmount * 5)
                        }
                        
                    }
                    .betAmountPickerModifier()
                    
                    Stepper(value: $gameViewModel.betAmountIndex, in: 0...gameViewModel.betOptions.count - 1) {
                        Text("\(Strings.betAmountText.rawValue)    \(gameViewModel.betAmount)")
                    }
                    .betAmountStepperStyle()
                    .onChange(of: gameViewModel.betAmountIndex) {
                        gameViewModel.betAmount = gameViewModel.betOptions[gameViewModel.betAmountIndex]
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
