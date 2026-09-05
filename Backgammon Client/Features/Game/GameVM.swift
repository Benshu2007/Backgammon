import SwiftUI

@Observable
final class GameViewModel {
    var diceVM              : DiceViewModel     = DiceViewModel();
    var boardVM             : BoardViewModel!;
    
    var turn                : Bool              = true
    var canFinishTurn       : Bool              = false
    var canBackMove         : Bool              = false
    var is_game_over        : Bool              = false
    var from_index          : Int               = 0
    var moves               : [Int]             = []
    var last_boards         : [BoardModel]      = []
    var last_moves_state    : [[Int]]           = []

    var event               : GameViewEvent?    = nil
    
    init() {
        diceVM.setOnRollClick(fn: rollOnClick)
        self.boardVM = BoardViewModel(turn: true, dicevm: diceVM, pieceOnClick: pieceOnClick)
    }
    
    func onFinishTurn() {
        turn.toggle()
        canFinishTurn = false;
        canBackMove = false;
        diceVM.enableRoll()
        last_boards = [];
        return
    }
    
    func onBackMove() {
        moves = last_moves_state.last!;
        var lastBoard = last_boards.last!;
        lastBoard.removeFutures();
        boardVM.loadBoard(from: lastBoard);
        canFinishTurn = false;
        
        if (hasMoveInAction()) {
            canBackMove = false;
        }
        
        last_boards.removeLast();
        last_moves_state.removeLast();
    }
    
    func hasMoveInAction() -> Bool {
        if (moves.count < 2 || moves.count == 3) {
            return false;
        }
        if (moves[0] == moves[1] && moves.count == 4) {
            return true;
        }
        if (moves[0] != moves[1] && moves.count == 2) {
            return true;
        }
        
        return false;
    }
    
    func pieceOnClick(group: PieceGroupModel) {
        do {
            if group.isFuture() {
                if try movePiece(group: group) {
                    is_game_over = true
                }
            } else if (try isValidClick(board: boardVM.board, turn: turn, from: group.index)) {
                boardVM.removeFutures()
                try handlePieceClick(group: group)
            }
        } catch InGameExceptions.turnBlocked {
            event = .turnBlocked
        } catch InGameExceptions.eatingMove {
            event = .eatingMove
        } catch {
            event = .unknownError
        }
    }

    private func handlePieceClick(group: PieceGroupModel) throws {
        let valmoves = try calculateValidMoves(board: boardVM.board, turn: turn, from: group.index, cubes: moves)
        
        for valmove in valmoves {
            boardVM.board.pieces[valmove].pieces.append(PieceModel(color: turn, future: true, isExtra: false))
        }
        
        from_index = group.index;
    }
    
    private func movePiece(group: PieceGroupModel) throws -> Bool {
        last_boards.append(boardVM.board);
        
        let from = from_index;
        let to = group.index;
        
        if (try isValidMove(board: boardVM.board, turn: turn, from: from, to: to)) {
            var die_used: Int = abs(to - from);
            
            if (from == 0) {
                boardVM.board.removeBarLast(for: turn)
                
                die_used = min(to, 25 - to);
            } else {
                boardVM.board.pieces[from].pieces.removeLast();
            }
            if (isEatingMove(board: boardVM.board, turn: turn, to: to)) {
                boardVM.board.addToBar(for: !turn, piece: boardVM.board.pieces[to].pieces[0]);
                boardVM.board.pieces[to].pieces.removeAll(where: {$0.future == false});
            }
            
            let future_piece_index = boardVM.board.pieces[to].pieces.firstIndex(where: {$0.future == true});
            boardVM.board.pieces[to].pieces[future_piece_index!].future = false;
            postMove(move: die_used);
        }
        
        if (isGameOver(board: boardVM.board, turn: turn)) {
            return true;
        }
        
        boardVM.removeFutures();
        
        return false;
    }
    
    private func postMove(move: Int) {
        last_moves_state.append(moves)
        
        canBackMove = true;
        if (moves.contains(move)) {
            moves.remove(at: moves.firstIndex(of: move)!)
        } else if (diceVM.currentRoll!.isDouble == false) {
            moves = [];
        } else {
            let q = move / moves[0];
            for _ in 0..<q {
                moves.removeLast();
            }
        }
        
        if (moves.isEmpty) {
            canFinishTurn = true;
        }
    }
    
    private func handleGameOver() {}
    
    private func rollOnClick() {
        Task {
            
            let roll = await diceVM.rollDice();
            moves = roll.isDouble ? Array(repeating: roll.die1, count: 4) : [roll.die1, roll.die2];
            
            if (moves.isEmpty) {
                event = .turnBlocked
            }
        }
    }
}

enum GameViewEvent: Identifiable {
    case turnBlocked
    case eatingMove
    case unknownError

    var id: String {
        switch self {
        case .turnBlocked: "turnBlocked"
        case .eatingMove: "eatingMove"
        case .unknownError: "unknownError"
        }
    }

    var title: String {
        switch self {
        case .turnBlocked: "Turn blocked"
        case .eatingMove: "Eating move required"
        case .unknownError: "Move failed"
        }
    }

    var message: String {
        switch self {
        case .turnBlocked:
            "You do not have a valid move for this roll."
        case .eatingMove:
            "You must make the eating move first."
        case .unknownError:
            "Something went wrong."
        }
    }
}
