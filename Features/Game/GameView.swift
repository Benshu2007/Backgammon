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
                VStack {
                    Text(verbatim: "Turn: \(vm.turn ? "White" : "Black")")
                    DiceView(vm: vm.diceVM)
                    HStack {
                        Button {
                            vm.onFinishTurn()
                        } label: {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundStyle(.green)
                                .font(.largeTitle)
                                .bold()
                        }
                        .opacity(vm.canFinishTurn ? 1 : 0)
                        .disabled(!vm.canFinishTurn)
                        
                        Button {
                            vm.onBackMove()
                        } label: {
                            Image(systemName: "arrow.uturn.backward.square.fill")
                                .foregroundStyle(.red)
                                .font(.largeTitle)
                                .bold()
                        }
                        .opacity(vm.canBackMove ? 1 : 0)
                        .disabled(!vm.canBackMove)
                    }
                }
            }
        }
    }
}

#Preview {
    GameView()
}
