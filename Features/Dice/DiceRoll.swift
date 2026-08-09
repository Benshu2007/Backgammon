//
//  DiceRoll.swift
//  Backgammon
//
//  Created by איתי בן שושן on 31/07/2026.
//

struct DiceRoll : Equatable {
    let die1    : Int
    let die2    : Int
    
    var isDouble : Bool { die1 == die2 }
}
