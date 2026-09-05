public struct BoardModel {
    var pieces          : [PieceGroupModel]
    var barPieces       : Bar
    var borneOffPieces  : BorneOff
    
    init() {
        self.barPieces = Bar()
        self.borneOffPieces = BorneOff()
        barPieces.black.pieces.append(PieceModel(color: false, future: false, isExtra: false))
        
        self.pieces = (0..<25).map { PieceGroupModel(index: $0, pieces: []) }
        
        for index in 1...5 {
            self.pieces[index] = PieceGroupModel(index: index, pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 2))
        }
    }
    
    func isBarEmpty() -> Bool {
        return barPieces.isBarEmpty()
    }
    
    func isBarEmpty(for white: Bool) -> Bool {
        return barPieces.isBarEmpty(for: white);
    }
    
    mutating func removeBarLast(for white: Bool) {
        if white {
            barPieces.white.pieces.removeLast()
        } else {
            barPieces.black.pieces.removeLast()
        }
    }
    
    mutating func addToBar(for white: Bool, piece: PieceModel) {
        if white {
            barPieces.white.pieces.append(piece)
        } else {
            barPieces.black.pieces.append(piece)
        }
    }
    
    mutating func addToBorneOff(for white: Bool, piece: PieceModel) {
        if white {
            borneOffPieces.white.pieces.append(piece)
        } else {
            borneOffPieces.black.pieces.append(piece)
        }
    }
    
    mutating func removeFutures() {
        pieces.forEach {
            pieces[$0.index].pieces.removeAll(where: { $0.future })
        }
    }
}

struct Bar {
    var white: PieceGroupModel
    var black: PieceGroupModel
    
    init() {
        self.white = PieceGroupModel(index: 0, pieces: [])
        self.black = PieceGroupModel(index: 0, pieces: [])
    }
    
    func isBarEmpty() -> Bool {
        return white.pieces.isEmpty && black.pieces.isEmpty
    }
    
    func isBarEmpty(for turn: Bool) -> Bool {
        return turn ? white.pieces.isEmpty : black.pieces.isEmpty
    }
}

struct BorneOff {
    var white: PieceGroupModel
    var black: PieceGroupModel
    
    init() {
        self.white = PieceGroupModel(index: 25, pieces: [])
        self.black = PieceGroupModel(index: 25, pieces: [])
    }
}
