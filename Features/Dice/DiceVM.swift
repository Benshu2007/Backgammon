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
    @Published private(set) var die1Value: Int = 0
    @Published private(set) var die2Value: Int = 0
    @Published private(set) var currentRoll: DiceRoll?
    @Published private(set) var isRolling: Bool = false
    
    private let randomProvider: RandomNumberProviding
    private let rollAnimationDuration: TimeInterval = 0.6
    
    init(randomProvider: RandomNumberProviding = SystemRandomNumberProvider()) {
        self.randomProvider = randomProvider;
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
        die1Value = finalDie1
        die2Value = finalDie2

        let roll = DiceRoll(die1: finalDie1, die2: finalDie2)
        currentRoll = roll
        isRolling = false
        return roll
    }
}
