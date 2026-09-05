import SwiftUI

struct BoardView: View {
    let vm: BoardViewModel

    private let frameColor = Color(#colorLiteral(red: 0.36, green: 0.22, blue: 0.14, alpha: 1))
    private let feltColor = Color(#colorLiteral(red: 0.55, green: 0.38, blue: 0.24, alpha: 1))
    private let barInlayColor = Color(#colorLiteral(red: 0.5620398116, green: 0.3076541096, blue: 0.2678253425, alpha: 1))
    private let lightPoint = Color(#colorLiteral(red: 0.90, green: 0.82, blue: 0.68, alpha: 1))
    private let darkPoint = Color(#colorLiteral(red: 0.45, green: 0.13, blue: 0.10, alpha: 1))
    private let frameThickness: CGFloat = 14
    private let barWidthRatio: CGFloat = 0.07
    private let pieceBoardRatio: CGFloat = 0.60
    private let borneOffWidthRatio: CGFloat = 0.11
    
    var body: some View {
        GeometryReader { geo in
            let railWidth = borneOffRailWidth(for: geo.size)
            let boardSize = CGSize(width: max(0, geo.size.width - railWidth), height: geo.size.height)
            
            HStack(spacing: 0) {
                ZStack {
                    Canvas { context, size in
                        draw(in: &context, size: size)
                    }
                    piecesOverlay(size: boardSize)
                }
                .frame(width: boardSize.width, height: boardSize.height)
                .onTapGesture {
                    vm.boardOnClick()
                }
                
                borneOffRail(size: CGSize(width: railWidth, height: boardSize.height))
                    .frame(width: railWidth, height: geo.size.height)
            }
        }
    }
    
    
    private func draw(in context: inout GraphicsContext, size: CGSize) {
        let fullRect = CGRect(origin: .zero, size: size)
        context.fill(Path(fullRect), with: .color(frameColor))

        let feltRect = fullRect.insetBy(dx: frameThickness, dy: frameThickness)
        context.fill(Path(feltRect), with: .color(feltColor))

        let barWidth = feltRect.width * barWidthRatio
        let barRect = CGRect(
            x: feltRect.midX - barWidth / 2,
            y: feltRect.minY,
            width: barWidth,
            height: feltRect.height
        )
        
        context.drawLayer { ctx in
            ctx.addFilter(.shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2))
            ctx.fill(Path(barRect), with: .color(frameColor))
        }

        let inlayInset: CGFloat = 7
        let barInlayRect = barRect.insetBy(dx: inlayInset, dy: inlayInset)
        context.fill(Path(barInlayRect), with: .color(barInlayColor))

        let halfWidth = (feltRect.width - barWidth) / 2
        let leftHalfRect = CGRect(x: feltRect.minX, y: feltRect.minY, width: halfWidth, height: feltRect.height)
        let rightHalfRect = CGRect(x: barRect.maxX, y: feltRect.minY, width: halfWidth, height: feltRect.height)

        drawQuadrantPair(in: &context, rect: leftHalfRect)
        drawQuadrantPair(in: &context, rect: rightHalfRect)
    }
    
    private func drawQuadrantPair(in context: inout GraphicsContext, rect: CGRect) {
        let triangleBase = rect.width / 6
        let triangleHeight = rect.height * 0.45

        for i in 0..<6 {
            let x = rect.minX + CGFloat(i) * triangleBase
            let isLight = i % 2 == 0

            let topTriangle = trianglePath(
                base: CGRect(x: x, y: rect.minY, width: triangleBase, height: triangleHeight),
                pointingDown: true
            )
            context.fill(topTriangle, with: .color(isLight ? lightPoint : darkPoint))

            let bottomTriangle = trianglePath(
                base: CGRect(x: x, y: rect.maxY - triangleHeight, width: triangleBase, height: triangleHeight),
                pointingDown: false
            )
            context.fill(bottomTriangle, with: .color(isLight ? lightPoint : darkPoint))
        }
    }

    private func trianglePath(base: CGRect, pointingDown: Bool) -> Path {
        var path = Path()
        if pointingDown {
            path.move(to: CGPoint(x: base.minX, y: base.minY))
            path.addLine(to: CGPoint(x: base.maxX, y: base.minY))
            path.addLine(to: CGPoint(x: base.midX, y: base.maxY))
        } else {
            path.move(to: CGPoint(x: base.minX, y: base.maxY))
            path.addLine(to: CGPoint(x: base.maxX, y: base.maxY))
            path.addLine(to: CGPoint(x: base.midX, y: base.minY))
        }
        path.closeSubpath()
        return path
    }

    @ViewBuilder
    private func piecesOverlay(size: CGSize) -> some View {
        let diameter = pieceDiameter(for: size)

        pointsLayer(size: size, diameter: diameter)
        barLayer(size: size, diameter: diameter)
    }

    @ViewBuilder
    private func pointsLayer(size: CGSize, diameter: CGFloat) -> some View {
        ForEach(vm.board.pieces, id: \.index) { group in
            let posInfo = pointBasePosition(for: group.index, size: size)
            
            let count = min(max(1, group.pieces.count), 5)
            let height = diameter * CGFloat(count)
            let offset = posInfo.inward.dy * diameter / 2

            let pieceVM = PieceViewModel(group: group, onclick: vm.pieceOnClick)

            PieceView(vm: pieceVM, pieceSize: diameter)
                .frame(width: diameter, height: height)
                .position(
                    x: posInfo.base.x,
                    y: posInfo.base.y + offset
                )
        }
    }
    
    @ViewBuilder
    private func barLayer(size: CGSize, diameter: CGFloat) -> some View {
        let barCenter = barCenterPoint(size: size)
        let whiteBar = vm.board.barPieces.white.pieces
        let blackBar = vm.board.barPieces.black.pieces
         
        let whiteCount = CGFloat(max(1, whiteBar.count))
        let blackCount = CGFloat(max(1, blackBar.count))
         
        PieceView(vm: PieceViewModel(pieces: whiteBar, index: 0, onclick: vm.pieceOnClick), pieceSize: diameter)
            .frame(width: diameter, height: diameter * whiteCount)
            .position(x: barCenter.x, y: barCenter.bottomy - diameter)
         
        PieceView(vm: PieceViewModel(pieces: blackBar, index: 0, onclick: vm.pieceOnClick), pieceSize: diameter)
            .frame(width: diameter, height: diameter * blackCount)
            .position(x: barCenter.x, y: barCenter.topy + diameter)
    }
    
    private func borneOffRail(size: CGSize) -> some View {
        ZStack {
            Rectangle()
                .fill(frameColor)
            
            VStack(spacing: 0) {
                borneOffSection(
                    pieces: vm.board.borneOffPieces.black.pieces,
                    color: false,
                    stacksFromBottom: false,
                    size: CGSize(width: size.width, height: (size.height - 5) / 2)
                )
                
                Rectangle()
                    .fill(Color.black.opacity(0.25))
                    .frame(height: 2)
                
                borneOffSection(
                    pieces: vm.board.borneOffPieces.white.pieces,
                    color: true,
                    stacksFromBottom: true,
                    size: CGSize(width: size.width, height: (size.height - 5) / 2)
                )
            }
            .padding(6)
        }
    }
    
    private func borneOffSection(
        pieces: [PieceModel],
        color: Bool,
        stacksFromBottom: Bool,
        size: CGSize
    ) -> some View {
        let pieceWidth = max(12, size.width * 0.58)
        let pieceHeight = (size.height - 3 * 17) / 15
        let placeholders = Array(repeating: PieceModel(color: color, future: false, isExtra: false), count: 15)
        let displayedPieces = pieces.isEmpty ? placeholders : pieces
        
        return VStack(spacing: 3) {
            if stacksFromBottom {
                Spacer(minLength: 0)
            }
            
            ForEach(Array(displayedPieces.enumerated()), id: \.offset) { _, piece in
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(piece.color ? Color.white.opacity(pieces.isEmpty ? 0.16 : 0.92) : Color.black.opacity(pieces.isEmpty ? 0.16 : 0.72))
                    .overlay {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .stroke(Color.white.opacity(piece.color ? 0.35 : 0.12), lineWidth: 1)
                    }
                    .frame(width: pieceWidth, height: pieceHeight)
            }
            
            if !stacksFromBottom {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(barInlayColor.opacity(0.75), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
    
    private func pointBasePosition(for index: Int, size: CGSize) -> (base: CGPoint, inward: CGVector) {
        let fullRect = CGRect(origin: .zero, size: size)
        let feltRect = fullRect.insetBy(dx: frameThickness, dy: frameThickness)
        let barWidth = feltRect.width * barWidthRatio
        let halfWidth = (feltRect.width - barWidth) / 2
        let triangleBase = halfWidth / 6

        let leftHalfX = feltRect.minX
        let rightHalfX = feltRect.minX + halfWidth + barWidth

        let rectX: CGFloat
        let localCol: Int
        let isTopRow: Bool

        if index > 12 {
            isTopRow = true
            let topIndex = index - 13
            if topIndex < 6 {
                rectX = leftHalfX
                localCol = topIndex
            } else {
                rectX = rightHalfX
                localCol = topIndex - 6
            }
        } else {
            isTopRow = false
            let bottomIndex = index - 1
            if bottomIndex < 6 {
                rectX = rightHalfX
                localCol = 5 - bottomIndex
            } else {
                rectX = leftHalfX
                localCol = 11 - bottomIndex
            }
        }

        let x = rectX + CGFloat(localCol) * triangleBase + triangleBase / 2
        let baseY = isTopRow ? feltRect.minY : feltRect.maxY
        let inwardDy: CGFloat = isTopRow ? 1 : -1

        return (
            base: CGPoint(x: x, y: baseY),
            inward: CGVector(dx: 0, dy: inwardDy)
        )
    }

    private func barCenterPoint(size: CGSize) -> (x: CGFloat, topy: CGFloat, bottomy: CGFloat) {
        let feltRect = CGRect(origin: .zero, size: size).insetBy(dx: frameThickness, dy: frameThickness)
        return (x: feltRect.midX, topy: feltRect.minY + 1, bottomy: feltRect.maxY - 1)
    }
    
    private func pieceDiameter(for size: CGSize) -> CGFloat {
        let feltRect = CGRect(origin: .zero, size: size).insetBy(dx: frameThickness, dy: frameThickness)
        let barWidth = feltRect.width * barWidthRatio
        let halfWidth = (feltRect.width - barWidth) / 2
        return (halfWidth / 6) * pieceBoardRatio
    }
    
    private func borneOffRailWidth(for size: CGSize) -> CGFloat {
        max(46, size.width * borneOffWidthRatio)
    }
    
    private func handleGameOver() {

    }
}

#Preview {
    BoardView(vm: BoardViewModel(turn: true, dicevm: DiceViewModel()))
}
