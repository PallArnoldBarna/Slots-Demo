//
//  ContentView.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 24.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var credits = 1000
    @State private var symbols = ["apple", "star", "cherry"]
    @State private var numbers = [
        [1, 2, 0],
        [1, 2, 0],
        [1, 2, 0]
    ]
    @State private var backgrounds: [[Color]] = [
        [.white, .white, .white],
        [.white, .white, .white],
        [.white, .white, .white]
    ]
    private var betAmount = 5
    @State private var isButtonDisabled = false
    
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
        }
    }
    
    func spinningProcess(onlyForMiddleRow: Bool = false) {
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
        
        if onlyForMiddleRow {
            
            checkMatch(
                indexRow1: 1, indexColumn1: 0,
                indexRow2: 1, indexColumn2: 1,
                indexRow3: 1, indexColumn3: 2,
                onlyForMiddleRow: true
            )
            
            if self.credits < self.betAmount {
                isButtonDisabled = true
            } else {
                self.credits -= self.betAmount
                isButtonDisabled = self.credits < self.betAmount
            }
            
        } else {
            
            // Check first row
//            checkMatch(
//                indexRow1: 0, indexColumn1: 0,
//                indexRow2: 0, indexColumn2: 1,
//                indexRow3: 0, indexColumn3: 2
//            )
//            
//            // Check second row
//            checkMatch(
//                indexRow1: 1, indexColumn1: 0,
//                indexRow2: 1, indexColumn2: 1,
//                indexRow3: 1, indexColumn3: 2
//            )
//            
//            // Check third row
//            checkMatch(
//                indexRow1: 2, indexColumn1: 0,
//                indexRow2: 2, indexColumn2: 1,
//                indexRow3: 2, indexColumn3: 2
//            )
            
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
            } else {
                self.credits -= self.betAmount * 5
                isButtonDisabled = self.credits < (self.betAmount * 5)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(red: 200/255, green: 143/255, blue: 32/255))
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundColor(Color(red: 228/255, green: 195/255, blue: 76/255))
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text("SwiftUI Slots")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                .scaleEffect(2)
                
                Spacer()
                
                Text("Credits: \(String(credits))")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white.opacity(0.5))
                    .cornerRadius(20)
                
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
                
                Button(action: {
                    
                    spinningProcess(onlyForMiddleRow: true)
                    
                }, label: {
                    Text("Spin only for middle row")
                        .fontWeight(.bold)
                        .padding(10)
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(20)
                }).disabled(isButtonDisabled)
                
                Button(action: {
                    
                    spinningProcess()
                    
                }, label: {
                    Text("Spin for everything")
                        .fontWeight(.bold)
                        .padding(10)
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(20)
                }).disabled(isButtonDisabled)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
