public struct BoardModel {
    var pieces          : [PieceGroupModel]
    var barPieces       : [PieceModel]
    
    init() {
        self.barPieces = [PieceModel(color: true, future: false, isExtra: false), PieceModel(color: true, future: false, isExtra: false), PieceModel(color: true, future: false, isExtra: false), PieceModel(color: false, future: false, isExtra: false)]
        
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
}
