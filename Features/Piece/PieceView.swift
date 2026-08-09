import SwiftUI

struct PieceView: View {
    let vm: PieceViewModel
    
    let pieceSize: CGFloat
    var pieces: [PieceModel] {
        vm.group.pieces
    }
    
    
    private let spacing: CGFloat = 0.70

    var body: some View {
        ZStack {
            ForEach(Array(pieces.enumerated()), id: \.offset) { index, piece in
                Button {
                    vm.onClick?(vm.group)
                } label: {
                    Piece(piece: piece, i: index)
                }
                .buttonStyle(.plain)
                .offset(y: checkerOffset(for: index))
                .frame(width: pieceSize, height: stackHeight)
            }
        }
        .scaleEffect(y: isBottomHalf ? 1 : -1)
    }

    private var stackHeight: CGFloat {
        let visibleOverlapCount = min(4, max(0, pieces.count - 1))
        return pieceSize * spacing * CGFloat(visibleOverlapCount) + pieceSize
    }

    private var isBottomHalf: Bool {
        vm.group.index > 12
    }
    
    @ViewBuilder
    private func Piece(piece: PieceModel, i: Int) -> some View {
        if piece.future {
            Circle()
                .strokeBorder(
                    piece.color ? .white : .black,
                    style: StrokeStyle(lineWidth: 2, dash: [3, 2])
                )
                .background(
                    Circle().fill(.ultraThinMaterial.opacity(0.5))
                )
                .opacity(0.7)
                .frame(width: pieceSize, height: pieceSize)
        } else if i > 4 {
            Circle()
                .fill(piece.color ? Color(#colorLiteral(red: 0.8348772526, green: 0.8348772526, blue: 0.8348772526, alpha: 1)) : Color(#colorLiteral(red: 0.3976883292, green: 0.3976883292, blue: 0.3976883292, alpha: 1)))
                .strokeBorder(piece.color ? Color(#colorLiteral(red: 0.6945466399, green: 0.6945466399, blue: 0.6945466399, alpha: 0.9998092064)) : Color(#colorLiteral(red: 0.2939586639, green: 0.2939586639, blue: 0.2939586639, alpha: 0.6249748243)), lineWidth: 6)
                .scaleEffect(0.9)
                .frame(width: pieceSize, height: pieceSize)
        } else {
            Circle()
                .fill(piece.color ? Color(#colorLiteral(red: 0.9114940763, green: 0.9114940763, blue: 0.9114940763, alpha: 1)) : Color(#colorLiteral(red: 0.199352473, green: 0.199352473, blue: 0.199352473, alpha: 1)))
                .strokeBorder(piece.color ? Color(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2460517473)) : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5512992832)), lineWidth: 6)
                .frame(width: pieceSize, height: pieceSize)
        }
    }

    private func checkerOffset(for index: Int) -> CGFloat {
        if index < 5 {
            return CGFloat(index) * (spacing * pieceSize)
        } else {
            return (CGFloat(index - 4) - 0.5) * (spacing * pieceSize)
        }
    }
}

#Preview {
    PieceView(vm: PieceViewModel(pieces: Array(repeating: PieceModel(color: true, future: false, isExtra: false), count: 6), index: 1), pieceSize: 40)
}
