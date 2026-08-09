//
//  Rules.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

public func calculateValidMoves(board: BoardModel, from: Int, cube1: Int, cube2: Int) -> [Int] {
    var moves: [Int] = calculateMoves(cube1: cube1, cube2: cube2);
    
    for move in moves {
        if (board.turn) {
            if (isValidMove(board: board, from: from, to: from - move)) {
                moves.append(from - move);
            }
        } else {
            if (isValidMove(board: board, from: from, to: from + move)) {
                moves.append(from + move);
            }
        }
        
        moves.remove(at: moves.firstIndex(of: move)!)
    }
    
    return moves;
}

private func calculateMoves(cube1: Int, cube2: Int) -> [Int] {
    let dr: DiceRoll = DiceRoll(die1: cube1, die2: cube2);
    if (dr.isDouble) {
        return [cube1, cube1 * 2, cube1 * 3, cube1 * 4]
    } else {
        return [cube1, cube2, cube1 + cube2]
    }
}

public func isValidClick(board: BoardModel, from: Int) -> Bool {
    return board.pieces[from].pieces[0].color == board.turn
}

func isGameOver(board: BoardModel) -> Bool {
    return !(board.pieces.contains(where: { !($0.pieces.isEmpty) && $0.pieces[0].color == board.turn}))
}

func isEatingMove(board: BoardModel, to: Int) -> Bool {
    return !board.pieces[to].pieces.isEmpty && board.pieces[to].pieces[0].color != board.turn && board.pieces[to].pieces.count == 1;
}

func isValidMove(board: BoardModel, from: Int, to: Int) -> Bool {
    return to <= 24 && to >= 1 && isValidClick(board: board, from: from) &&
    (board.pieces[to].pieces.count <= 1 || board.pieces[to].pieces[0].color == board.turn)
}
