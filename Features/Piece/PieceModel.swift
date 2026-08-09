import SwiftUI

struct PieceModel : Equatable, Identifiable {
    let id              = UUID();
    var color           : Bool; // white - true, black = false
    var future          : Bool;
    var isExtra         : Bool;
}

struct PieceGroupModel : Equatable {
    let index           : Int;
    var pieces          : [PieceModel]
}
