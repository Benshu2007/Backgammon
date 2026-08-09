//
//  GameView.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import SwiftUI

struct GameView: View {
    @State private var vm = GameViewModel()
    
    var body: some View {
        ZStack {
            HStack {
                BoardView(vm: vm.boardVM)
                DiceView(vm: vm.diceVM)
            }
        }
    }
}

#Preview {
    GameView()
}
