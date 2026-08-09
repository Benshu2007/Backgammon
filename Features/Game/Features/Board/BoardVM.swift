import Observation
import SwiftUI

@Observable
final class BoardViewModel {
    var board: BoardModel
    
    var diceVM: DiceViewModel

    var pieceOnClick: ((PieceGroupModel) -> Void)?
    
    init(turn: Bool, dicevm: DiceViewModel, pieceOnClick: ((PieceGroupModel) -> Void)? = nil) {
        self.board = BoardModel()
        self.diceVM = dicevm
        self.pieceOnClick = pieceOnClick
    }
    
    func removeFutures() {
        for index in board.pieces.indices {
            board.pieces[index].pieces.removeAll { $0.future }
        }
    }
    
    func boardOnClick() {
        removeFutures()
    }
}
