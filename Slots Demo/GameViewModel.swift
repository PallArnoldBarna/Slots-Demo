//
//  GameViewModel.swift
//  Slots Demo
//
//  Created by Pall Arnold Barna on 02.03.2026.
//

import SwiftUI
internal import Combine

class GameViewModel: ObservableObject {
    @Published var credits = 1000
    @Published var symbols = [
        Symbols.apple.rawValue, Symbols.star.rawValue, Symbols.cherry.rawValue,
        Symbols.seven.rawValue, Symbols.lemon.rawValue, Symbols.clover.rawValue
    ]
    @Published var numbers = [
        [1, 2, 0],
        [4, 3, 5],
        [1, 4, 3]
    ]
    @Published var backgrounds: [[Color]] = [
        [.white, .white, .white],
        [.white, .white, .white],
        [.white, .white, .white]
    ]
    @Published var betAmount = 5
    let betOptions = [5, 10, 25, 50]
    @Published var betAmountIndex = 0
    @Published var isOneRowButtonDisabled = false
    @Published var isButtonDisabled = false
    @Published var win = false
    @Published var timer: Timer?
    @Published var autoSpinOneRow = false
    @Published var autoSpin = false
    
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
                self.spinningProcess(onlyForMiddleRow: onlyForMiddleRow)
            }
        } else {
            invalidateTimer()
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
