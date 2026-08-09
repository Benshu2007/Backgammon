public struct GameModel {
    var board:  BoardModel
    var turn:   Bool
    
    init(turn: Bool) {
        self.board = BoardModel(turn: turn)
        self.turn = turn
    }
}
