import SwiftUI

@Observable
final class GameViewModel {
    var diceVM: DiceViewModel = DiceViewModel()

    var boardVM: BoardViewModel!;

    var cubes: [Int] { [diceVM.die1Value, diceVM.die2Value] }
    
    init() {
        self.boardVM = BoardViewModel(turn: true, dicevm: diceVM)
    }

    private func handleGameOver() {}
}
