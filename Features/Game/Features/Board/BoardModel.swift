public struct BoardModel {
    var pieces          : [PieceGroupModel]
    var barPieces       : Bar
    
    init() {
        self.barPieces = Bar()
        barPieces.black.pieces.append(PieceModel(color: false, future: false, isExtra: false))
        
        self.pieces = (0..<25).map { PieceGroupModel(index: $0, pieces: []) }
        
        self.pieces[1] = PieceGroupModel(index: 1, pieces: Array(repeating: PieceModel(color: false, future: false, isExtra: false), count: 2))
        self.pieces[6] = PieceGroupModel(index: 6, pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 5))
        self.pieces[8] = PieceGroupModel(index: 8, pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 3))
        self.pieces[12] = PieceGroupModel(index: 12, pieces: Array(repeating: PieceModel(color: false, future: false, isExtra: false), count: 5))
        self.pieces[13] = PieceGroupModel(index: 13, pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 5))
        self.pieces[17] = PieceGroupModel(index: 17, pieces: Array(repeating: PieceModel(color: false, future: false, isExtra: false), count: 3))
        self.pieces[19] = PieceGroupModel(index: 19, pieces: Array(repeating: PieceModel(color: false, future: false, isExtra: false), count: 5))
        self.pieces[24] = PieceGroupModel(index: 24, pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 2))
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
