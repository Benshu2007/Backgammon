//
//  GameView.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import SwiftUI

struct GameView: View {
    @State private var vm: GameViewModel = GameViewModel()
        
    var body: some View {
        ZStack(alignment: .top) {
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
            
            if let event = vm.event {
                GameNotificationView(event: event) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                        vm.event = nil
                    }
                }
                .padding(.top, 18)
                .padding(.horizontal, 24)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.86), value: vm.event?.id)
        .task(id: vm.event?.id) {
            guard vm.event != nil else { return }
            try? await Task.sleep(nanoseconds: 2_800_000_000)
            guard !Task.isCancelled else { return }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                vm.event = nil
            }
        }
    }
}

private struct GameNotificationView: View {
    let event: GameViewEvent
    let onDismiss: () -> Void
    
    private var systemImage: String {
        switch event {
        case .turnBlocked: "hand.raised.fill"
        case .unknownError: "exclamationmark.triangle.fill"
        }
    }
    
    private var tint: Color {
        switch event {
        case .turnBlocked: .orange
        case .unknownError: .red
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 34, height: 34)
                .background(tint.opacity(0.15), in: Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(event.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 14)
        .padding(.trailing, 10)
        .padding(.vertical, 12)
        .frame(maxWidth: 420, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.white.opacity(0.38), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: 18, y: 10)
    }
}

#Preview {
    GameView()
}
