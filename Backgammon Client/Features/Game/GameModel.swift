public struct GameModel {
    var board:  BoardModel
    var turn:   Bool
    
    init(turn: Bool) {
        self.board = BoardModel()
        self.turn = turn
    }
}
