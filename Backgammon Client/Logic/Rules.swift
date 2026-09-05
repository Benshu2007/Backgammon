//
//  Rules.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

func isTurnBlocked(board: BoardModel, turn: Bool, cubes: [Int]) -> Bool {
    var pieces : [PieceGroupModel];
    if (board.isBarEmpty(for: turn) == false) {
        if calculateValidMoves(board: board, turn: turn, from: 0, cubes: cubes).isEmpty {
            return true
        }
        return false
    }
    pieces = board.pieces.filter({$0.pieces.isEmpty == false &&  $0.isFuture() == false && $0.pieces[0].color == turn})
    
    for piece in pieces {
        if (calculateValidMoves(board: board, turn: turn, from: piece.index, cubes: cubes).count > 0) {
            return false;
        }
    }
    
    return true;
}

func calculateValidMoves(board: BoardModel, turn: Bool, from: Int, cubes: [Int]) -> [Int] {
    if cubes.isEmpty {
        return [];
    }
    var valmoves: [Int] = [];
    
    let firstTo = turn ? (from == 0 ? 25 : from) - cubes[0] : from + cubes[0]
    if (cubes.count == 1) {
        if isValidMove(board: board, turn: turn, from: from, to: firstTo) {
            return [firstTo];
        }
        return [];
    }
    
    let secondTo = turn ? (from == 0 ? 25 : from) - cubes[1] : from + cubes[1]
    if (!isValidMove(board: board, turn: turn, from: from, to: firstTo) && !isValidMove(board: board, turn: turn, from: from, to: secondTo)) {
        return [];
    }
    
    let sumTo = turn ? (from == 0 ? 25 : from) - (cubes[0] + cubes[1]) : from + (cubes[0] + cubes[1])
    if (cubes[0] != cubes[1]) {
        if (isValidMove(board: board, turn: turn, from: from, to: firstTo)) {
            valmoves.append(firstTo);
        }
        if (isValidMove(board: board, turn: turn, from: from, to: secondTo)) {
            valmoves.append(secondTo);
        }
        if (valmoves.count > 0 && isValidMove(board: board, turn: turn, from: from, to: sumTo)) {
            valmoves.append(sumTo);
        }
    } else {
        for i in 0..<cubes.count {
            let to = turn ? (from == 0 ? 25 : from) - cubes[0] * (i + 1) : from + cubes[0] * (i + 1)
            if (isValidMove(board: board, turn: turn, from: from, to: to)) {
                valmoves.append(to)
            }
        }
    }
    
    return valmoves;
}

public func isValidClick(board: BoardModel, turn: Bool, from: Int) -> Bool {
    if (!board.isBarEmpty(for: turn) && from != 0) {
        return false
    }
    return (from != 0 && board.pieces[from].pieces[0].color == turn) || (from == 0 && !board.barPieces.isBarEmpty(for: turn))
}

func isGameOver(board: BoardModel, turn: Bool) -> Bool {
    return !(board.pieces.contains(where: { !($0.pieces.isEmpty) && $0.pieces[0].color == turn}))
}

func isEatingMove(board: BoardModel, turn: Bool, to: Int) -> Bool {
    return !(board.pieces[to].pieces.isEmpty) && board.pieces[to].pieces[0].color != turn && board.pieces[to].pieces.count(where: {$0.future == false}) == 1;
}

func isValidMove(board: BoardModel, turn: Bool, from: Int, to: Int) -> Bool {
    return (to <= 24 && to >= 1 && isValidClick(board: board, turn: turn, from: from) &&
            (board.pieces[to].pieces.count(where: {$0.future == false}) <= 1 || board.pieces[to].pieces[0].color == turn))
}
