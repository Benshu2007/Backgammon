//
//  Rules.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

func calculateValidMoves(board: BoardModel, turn: Bool, from: Int, moves: [Int]) -> [Int] {
    var valmoves: [Int] = [];
    
    for move in moves {
        if (turn) {
            if (isValidMove(board: board, turn: turn, from: from, to: from - move)) {
                valmoves.append(from - move);
            }
        } else {
            if (isValidMove(board: board, turn: turn, from: from, to: from + move)) {
                valmoves.append(from + move);
            }
        }
    }
    
    return valmoves;
}

func calculateMoves(roll: DiceRoll) -> [Int] {
    if (roll.isDouble) {
        return [roll.die1, roll.die1 * 2, roll.die1 * 3, roll.die1 * 4]
    } else {
        return [roll.die1, roll.die2, roll.die1 + roll.die2]
    }
}

public func isValidClick(board: BoardModel, turn: Bool, from: Int) -> Bool {
    return board.pieces[from].pieces[0].color == turn
}

func isGameOver(board: BoardModel, turn: Bool) -> Bool {
    return !(board.pieces.contains(where: { !($0.pieces.isEmpty) && $0.pieces[0].color == turn}))
}

func isEatingMove(board: BoardModel, turn: Bool, to: Int) -> Bool {
    return !board.pieces[to].pieces.isEmpty && board.pieces[to].pieces[0].color != turn && board.pieces[to].pieces.count == 1;
}

func isValidMove(board: BoardModel, turn: Bool, from: Int, to: Int) -> Bool {
    return to <= 24 && to >= 1 && isValidClick(board: board, turn: turn, from: from) &&
    (board.pieces[to].pieces.count <= 1 || board.pieces[to].pieces[0].color == turn)
}
