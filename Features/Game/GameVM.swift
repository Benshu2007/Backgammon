import SwiftUI

@Observable
final class GameViewModel {
    var diceVM              : DiceViewModel = DiceViewModel();
    var boardVM             : BoardViewModel!;
    
    var turn                : Bool = true;
    var canFinishTurn       : Bool = false
    var availableMoves      : [Int] = []
    var is_game_over        : Bool = false
    var from_index          : Int = 0
    
    init() {
        diceVM.setOnRollClick(fn: rollOnClick)
        self.boardVM = BoardViewModel(turn: true, dicevm: diceVM, pieceOnClick: pieceOnClick)
    }
    
    func onFinishTurn() {
        turn.toggle()
        canFinishTurn = false;
        diceVM.enableRoll()
        return
    }
    
    func pieceOnClick(group: PieceGroupModel) {
        if group.pieces.contains(where: {$0.future == true}) {
            if movePiece(group: group) {
                is_game_over = true
            }
            if (!availableMoves.isEmpty) {
                availableMoves.removeLast()
                if !availableMoves.isEmpty {
                    let i = availableMoves.firstIndex(where: {$0 == abs(group.index - from_index)})
                    availableMoves.remove(at: i!)
                }
            }
            if (availableMoves.isEmpty) {
                canFinishTurn = true;
            }
            return
        } else if (isValidClick(board: boardVM.board, turn: turn, from: group.index)) {
            boardVM.removeFutures()
            handlePieceClick(group: group)
        }
    }

    private func handlePieceClick(group: PieceGroupModel) {
        let valmoves = calculateValidMoves(board: boardVM.board, turn: turn, from: group.index, moves: availableMoves)
        
        for valmove in valmoves {
            boardVM.board.pieces[valmove].pieces.append(PieceModel(color: turn, future: true, isExtra: false))
        }
        
        from_index = group.index;
    }
    
    private func movePiece(group: PieceGroupModel) -> Bool {
        let from = from_index;
        let to = group.index;
        
        if (isValidMove(board: boardVM.board, turn: turn, from: from, to: to)) {
            if (isEatingMove(board: boardVM.board, turn: turn, to: to)) {
                boardVM.board.barPieces.append(boardVM.board.pieces[to].pieces[0]);
                boardVM.board.pieces[to].pieces.removeAll();
            }
            
            let future_piece_index = boardVM.board.pieces[to].pieces.firstIndex(where: {$0.future == true});
            
            boardVM.board.pieces[to].pieces[future_piece_index!].future = false;
            boardVM.board.pieces[from].pieces.removeLast();
        }
        
        if (isGameOver(board: boardVM.board, turn: turn)) {
            return true;
        }
        
        boardVM.removeFutures();
        
        return false;
    }
    
    private func handleGameOver() {}
    
    private func rollOnClick() {
        Task {
            var roll: DiceRoll;
            await roll = diceVM.rollDice();
            availableMoves = calculateMoves(roll: roll);
        }
    }
}
