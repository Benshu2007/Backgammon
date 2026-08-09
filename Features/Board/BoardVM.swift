import Observation
import SwiftUI

@Observable
final class BoardViewModel {
    var board: BoardModel
    
    var diceVM: DiceViewModel
    
    var from_index = 0
    var is_game_over: Bool = false
    
    var cubes_state: DiceRoll {
        DiceRoll(die1: diceVM.die1Value, die2: diceVM.die2Value)
    }
    
    init(turn: Bool, dicevm: DiceViewModel) {
        self.board = BoardModel(turn: turn)
        self.diceVM = dicevm
    }
    
    private func removeFutures() {
        for index in board.pieces.indices {
            board.pieces[index].pieces.removeAll { $0.future }
        }
    }

    private func handlePieceClick(group: PieceGroupModel) {
        if (cubes_state.die1 == 0 || cubes_state.die2 == 0) {
            return
        }
        let valMoves = calculateValidMoves(board: board, from: group.index, cube1: diceVM.die1Value, cube2: diceVM.die2Value);
        for valmove in valMoves {
            board.pieces[valmove].pieces.append(PieceModel(color: board.turn, future: true, isExtra: false))
        }
        
        from_index = group.index;
    }

    func pieceOnClick(group: PieceGroupModel) {
        if group.pieces.contains(where: {$0.future == true}) {
            if movePiece(group: group) {
                is_game_over = true
            }
            return
        } else if (isValidClick(board: board, from: group.index)) {
            removeFutures()
            handlePieceClick(group: group)
        }
    }
    
    func boardOnClick() {
        removeFutures()
    }
    
    private func movePiece(group: PieceGroupModel) -> Bool {
        let from = from_index;
        let to = group.index;
        
        if (isValidMove(board: board, from: from, to: to)) {
            if (isEatingMove(board: board, to: to)) {
                board.barPieces.append(board.pieces[to].pieces[0]);
                board.pieces[to].pieces.removeAll();
            }
            
            let future_piece_index = board.pieces[to].pieces.firstIndex(where: {$0.future == true});
            
            board.pieces[to].pieces[future_piece_index!].future = false;
            board.pieces[from].pieces.removeLast();
        }
        
        if (isGameOver(board: board)) {
            return true;
        }
        
        removeFutures();
        
        board.turn.toggle();
        
        return false;
    }
}
