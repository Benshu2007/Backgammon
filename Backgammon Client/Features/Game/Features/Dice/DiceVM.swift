//
//  DiceVM.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

import Foundation
internal import Combine

@MainActor
final class DiceViewModel: ObservableObject {
    @Published private(set) var die1Value       : Int = 0
    @Published private(set) var die2Value       : Int = 0
    @Published private(set) var currentRoll     : DiceRoll?
    @Published private(set) var isRolling       : Bool = false
    @Published private(set) var rollEnabled     : Bool = true;
    
    private let randomProvider: RandomNumberProviding
    private let rollAnimationDuration: TimeInterval = 0.6
    
    var onRollClick: (() -> Void)?
    
    init(onRollClick: (() -> Void)? = nil) {
        self.randomProvider = SystemRandomNumberProvider()
        self.onRollClick = onRollClick
    }

    init(randomProvider: RandomNumberProviding, onRollClick: (() -> Void)? = nil) {
        self.randomProvider = randomProvider
        self.onRollClick = onRollClick
    }
    
    func setOnRollClick(fn: @escaping () -> Void) {
        self.onRollClick = fn;
    }
    
    func rollDice() async -> DiceRoll {
        guard !isRolling else { return currentRoll ?? DiceRoll(die1: 1, die2: 1) }
        isRolling = true

        let animationSteps = 8
        for _ in 0..<animationSteps {
            die1Value = randomProvider.rollDie()
            die2Value = randomProvider.rollDie()
            try? await Task.sleep(nanoseconds: UInt64(rollAnimationDuration / Double(animationSteps) * 1_000_000_000))
        }

        let finalDie1 = randomProvider.rollDie()
        let finalDie2 = randomProvider.rollDie()
        die1Value = 6
        die2Value = 4

        let roll = DiceRoll(die1: 6, die2: 4)
        currentRoll = roll
        isRolling = false
        
        rollEnabled = false
        return roll
    }
    
    func enableRoll() -> Void {
        rollEnabled = true
    }
}
