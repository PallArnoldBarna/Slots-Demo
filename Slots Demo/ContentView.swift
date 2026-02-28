//
//  ContentView.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 24.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var credits = 1000
    @State private var symbols = [
        Symbols.apple.rawValue, Symbols.star.rawValue, Symbols.cherry.rawValue,
        Symbols.seven.rawValue, Symbols.lemon.rawValue, Symbols.clover.rawValue
    ]
    @State private var numbers = [
        [1, 2, 0],
        [4, 3, 5],
        [1, 4, 3]
    ]
    @State private var backgrounds: [[Color]] = [
        [.white, .white, .white],
        [.white, .white, .white],
        [.white, .white, .white]
    ]
    @State private var betAmount = 5
    private let betOptions = [5, 10, 25, 50]
    @State private var isOneRowButtonDisabled = false
    @State private var isButtonDisabled = false
    @State private var win = false
    @State private var timer: Timer?
    @State private var autoSpinOneRow = false
    @State private var autoSpin = false
    
    func checkMatch(
        indexRow1: Int, indexColumn1: Int,
        indexRow2: Int, indexColumn2: Int,
        indexRow3: Int, indexColumn3: Int,
        onlyForMiddleRow: Bool = false
    ) {
        if self.numbers[indexRow1][indexColumn1] == self.numbers[indexRow2][indexColumn2]
            && self.numbers[indexRow2][indexColumn2] == self.numbers[indexRow3][indexColumn3] {
            self.backgrounds[indexRow1][indexColumn1] = .green
            self.backgrounds[indexRow2][indexColumn2] = .green
            self.backgrounds[indexRow3][indexColumn3] = .green
            
            if onlyForMiddleRow {
                self.credits += self.betAmount * 5
            } else {
                self.credits += self.betAmount * 25
            }
            
            self.win = true
        }
    }
    
    func spinningProcess(onlyForMiddleRow: Bool) {
        
        if onlyForMiddleRow {
            guard self.credits >= self.betAmount else {
                isOneRowButtonDisabled = true
                autoSpinOneRow = false
                invalidateTimer()
                
                return
            }
        } else {
            guard self.credits >= (self.betAmount * 5) else {
                isButtonDisabled = true
                autoSpin = false
                invalidateTimer()
                
                return
            }
        }
        
        self.backgrounds = self.backgrounds.map { row in
            row.map { _ in
                Color.white
            }
        }
        
        self.numbers = self.numbers.map { row in
            row.map { _ in
                Int.random(in: 0...symbols.count - 1)
            }
        }
        
        self.win = false
        
        if onlyForMiddleRow {
            
            checkMatch(
                indexRow1: 1, indexColumn1: 0,
                indexRow2: 1, indexColumn2: 1,
                indexRow3: 1, indexColumn3: 2,
                onlyForMiddleRow: true
            )
            
            if self.credits < self.betAmount {
                isOneRowButtonDisabled = true
                autoSpinOneRow = false
                
                invalidateTimer()
            } else {
                self.credits -= self.betAmount
                isOneRowButtonDisabled = self.credits < self.betAmount
                
                if isOneRowButtonDisabled {
                    autoSpinOneRow = false
                    invalidateTimer()
                }
            }
            
        } else {
            
            // Check first row
            checkMatch(
                indexRow1: 0, indexColumn1: 0,
                indexRow2: 0, indexColumn2: 1,
                indexRow3: 0, indexColumn3: 2
            )
            
            // Check second row
            checkMatch(
                indexRow1: 1, indexColumn1: 0,
                indexRow2: 1, indexColumn2: 1,
                indexRow3: 1, indexColumn3: 2
            )
            
            // Check third row
            checkMatch(
                indexRow1: 2, indexColumn1: 0,
                indexRow2: 2, indexColumn2: 1,
                indexRow3: 2, indexColumn3: 2
            )
            
            // Check main diagonal
            checkMatch(
                indexRow1: 0, indexColumn1: 0,
                indexRow2: 1, indexColumn2: 1,
                indexRow3: 2, indexColumn3: 2
            )
            
            // Check anti diagonal
            checkMatch(
                indexRow1: 0, indexColumn1: 2,
                indexRow2: 1, indexColumn2: 1,
                indexRow3: 2, indexColumn3: 0
            )
            
            if self.credits < (self.betAmount * 5) {
                isButtonDisabled = true
                autoSpin = false
                
                invalidateTimer()
            } else {
                self.credits -= self.betAmount * 5
                isButtonDisabled = self.credits < (self.betAmount * 5)
                
                if isButtonDisabled {
                    autoSpin = false
                    invalidateTimer()
                }
            }
        }
    }
    
    func autoSpinning(isOn: Bool, onlyForMiddleRow : Bool) {
        if isOn {
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                spinningProcess(onlyForMiddleRow: onlyForMiddleRow)
            }
        } else {
            invalidateTimer()
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
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
                
                Text("\(Strings.creditsText.rawValue) \(String(credits))")
                    .creditsTextStyle(win: win, credits: credits)
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[0][0]], background: $backgrounds[0][0])
                        
                        CardView(symbol: $symbols[numbers[0][1]], background: $backgrounds[0][1])
                        
                        CardView(symbol: $symbols[numbers[0][2]], background: $backgrounds[0][2])
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[1][0]], background: $backgrounds[1][0])
                        
                        CardView(symbol: $symbols[numbers[1][1]], background: $backgrounds[1][1])
                        
                        CardView(symbol: $symbols[numbers[1][2]], background: $backgrounds[1][2])
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[2][0]], background: $backgrounds[2][0])
                        
                        CardView(symbol: $symbols[numbers[2][1]], background: $backgrounds[2][1])
                        
                        CardView(symbol: $symbols[numbers[2][2]], background: $backgrounds[2][2])
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        Button(action: {
                            
                            withAnimation(.easeOut) {
                                spinningProcess(onlyForMiddleRow: true)
                            }
                            
                        }, label: {
                            Text(Strings.spinOnlyMiddleRowButtonText.rawValue)
                                .buttonTextStyle()
                        }).disabled(isOneRowButtonDisabled)
                        
                        Text("\(Strings.betText.rawValue) \(betAmount)")
                        
                        Toggle(Strings.autoSpinText.rawValue, isOn: $autoSpinOneRow)
                            .autoplayToggleStyle()
                            .onChange(of: autoSpinOneRow) {
                                autoSpinning(isOn: autoSpinOneRow, onlyForMiddleRow: true)
                            }
                            
                    }
                    
                    VStack {
                        Button(action: {
                            
                            withAnimation(.easeOut) {
                                spinningProcess(onlyForMiddleRow: false)
                            }
                            
                        }, label: {
                            Text(Strings.spinButtonText.rawValue)
                                .buttonTextStyle()
                        }).disabled(isButtonDisabled)
                        
                        Text("\(Strings.betText.rawValue) \(betAmount * 5)")
                        
                        Toggle(Strings.autoSpinText.rawValue, isOn: $autoSpin)
                            .autoplayToggleStyle()
                            .onChange(of: autoSpin) {
                                autoSpinning(isOn: autoSpin, onlyForMiddleRow: false)
                            }
                    }
                }
                
                Spacer()
                
                HStack {
                    Text(Strings.betAmountText.rawValue)
                    
                    Spacer()
                    
                    Picker(Strings.betAmountText.rawValue, selection: $betAmount) {
                        ForEach(betOptions, id: \.self) { amount in
                            Text("\(amount)").tag(amount)
                        }
                    }
                    .betAmountPickerStyle()
                    .onChange(of: betAmount) {
                        isOneRowButtonDisabled = credits < betAmount
                        isButtonDisabled = credits < (betAmount * 5)
                    }
                    
                }
                .betAmountPickerModifier()
            }
        }
    }
}

enum Strings: String {
    case titleText = "Slots Game"
    case creditsText = "Credits"
    case spinOnlyMiddleRowButtonText = "Spin only for middle row"
    case spinButtonText = "Spin for everything"
    case betText = "Bet"
    case betAmountText = "Bet Amount"
    case autoSpinText = "Auto-spin"
}

enum Symbols: String {
    case starSystem = "star.fill"
    case star = "star"
    case apple = "apple"
    case cherry = "cherry"
    case seven = "seven"
    case clover = "clover"
    case lemon = "lemon"
}

struct BetAmountPickerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 150)
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

#Preview {
    ContentView()
}
