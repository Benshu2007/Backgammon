import SwiftUI

struct DiceView: View {
    @StateObject var vm: DiceViewModel
    @State private var rollSpin: Double = 0

    var body: some View {
        VStack(spacing: 18) {
            HStack(spacing: 14) {
                DieFaceView(value: vm.die1Value, isRolling: vm.isRolling)
                    .rotation3DEffect(.degrees(vm.isRolling ? 22 : 0), axis: (x: 0.7, y: 1, z: 0.2))
                    .rotationEffect(.degrees(rollSpin))

                DieFaceView(value: vm.die2Value, isRolling: vm.isRolling)
                    .rotation3DEffect(.degrees(vm.isRolling ? -22 : 0), axis: (x: 1, y: 0.6, z: 0.2))
                    .rotationEffect(.degrees(-rollSpin))
            }
            .scaleEffect(vm.isRolling ? 1.08 : 1)
            .animation(.smooth(duration: 0.18), value: vm.isRolling)
            .animation(.bouncy(duration: 0.28, extraBounce: 0.18), value: vm.die1Value)
            .animation(.bouncy(duration: 0.28, extraBounce: 0.18), value: vm.die2Value)

            if let roll = vm.currentRoll, roll.isDouble {
                Text("Doubles! 4 moves available")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                    .transition(.scale.combined(with: .opacity))
            }

            Button {
                withAnimation(.easeInOut(duration: 0.6)) {
                    rollSpin += 360
                }

                Task {
                    await vm.rollDice()
                }
            } label: {
                Label("Roll", systemImage: vm.isRolling ? "dice.fill" : "arrow.triangle.2.circlepath")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(.linearGradient(
                                colors: [Color.indigo, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    )
                    .shadow(color: .teal.opacity(vm.isRolling ? 0.45 : 0.22), radius: vm.isRolling ? 16 : 8, y: 6)
            }
            .buttonStyle(.plain)
            .disabled(vm.isRolling)
            .opacity(vm.isRolling ? 0.72 : 1)
            .scaleEffect(vm.isRolling ? 0.96 : 1)
            .animation(.smooth(duration: 0.2), value: vm.isRolling)
        }
        .padding(20)
    }
}

struct DieFaceView: View {
    let value: Int
    let isRolling: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(.linearGradient(
                colors: [Color.white, Color(red: 0.90, green: 0.94, blue: 0.98)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: 68, height: 68)
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.9), lineWidth: 1.5)
            }
            .overlay {
                PipLayout(value: value)
                    .padding(13)
            }
            .shadow(color: .black.opacity(isRolling ? 0.28 : 0.18), radius: isRolling ? 18 : 10, y: isRolling ? 12 : 6)
            .scaleEffect(isRolling ? 0.94 : 1)
            .animation(.spring(response: 0.24, dampingFraction: 0.62), value: value)
            .animation(.smooth(duration: 0.18), value: isRolling)
    }
}

private struct PipLayout: View {
    let value: Int

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(0..<9, id: \.self) { index in
                Circle()
                    .fill(shouldShowPip(at: index) ? Color(red: 0.10, green: 0.13, blue: 0.18) : .clear)
                    .scaleEffect(shouldShowPip(at: index) ? 1 : 0.25)
                    .animation(.spring(response: 0.22, dampingFraction: 0.65), value: value)
            }
        }
    }

    private func shouldShowPip(at index: Int) -> Bool {
        switch value {
        case 1:
            return [4].contains(index)
        case 2:
            return [0, 8].contains(index)
        case 3:
            return [0, 4, 8].contains(index)
        case 4:
            return [0, 2, 6, 8].contains(index)
        case 5:
            return [0, 2, 4, 6, 8].contains(index)
        case 6:
            return [0, 2, 3, 5, 6, 8].contains(index)
        default:
            return false
        }
    }
}

#Preview {
    DiceView(vm: DiceViewModel())
}
