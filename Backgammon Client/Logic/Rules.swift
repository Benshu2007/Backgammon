//
//  Rules.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

func lastIndexInHouse(board: BoardModel, color: Bool) -> Int {
    if (color) {
        for i in (1...6).reversed() {
            if !board.pieces[i].pieces.isEmpty {
                return i;
            }
        }
    }
    
    return 0;
}

func isReadyForBearing(board: BoardModel, color: Bool) -> Bool {
    if (!board.isBarEmpty(for: color)) {
        return false;
    }
    if color {
        for i in 7..<25 {
            if board.pieces[i].pieces.count(where: {$0.color == color}) > 0 {
                return false
            }
        }
        return true;
    }
    
    
    for i in 1..<18 {
        if  board.pieces[i].pieces.count(where: {$0.color == color}) > 0 {
            return false
        }
    }
    
    return true;
}

func isHouseFulled(board: BoardModel, color: Bool) -> Bool {
    if color {
        for i in 1..<7 {
            if board.pieces[i].pieces.count(where: {$0.color == color}) < 2 {
                return false
            }
        }
        
        return true;
    } else {
        for i in 18..<25 {
            if !board.pieces[i].pieces.isEmpty && board.pieces[i].pieces[0].color == color && board.pieces[i].pieces.count < 2 {
                return false
            }
        }
        
        return true;
    }
}

func isTurnBlocked(board: BoardModel, turn: Bool, cubes: [Int]) -> Bool {
    //TODO:: fix
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
    return (isReadyForBearing(board: board, color: turn) && to < 1) || (to <= 24 && to >= 1 && isValidClick(board: board, turn: turn, from: from) &&
            (board.pieces[to].pieces.count(where: {$0.future == false}) <= 1 || board.pieces[to].pieces[0].color == turn))
}
