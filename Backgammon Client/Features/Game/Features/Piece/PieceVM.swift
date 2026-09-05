import SwiftUI

@Observable
final class PieceViewModel {
    var group: PieceGroupModel;
    let onClick: ((PieceGroupModel) -> Void)?;
    
    init(pieces: [PieceModel], index: Int, onclick: ((PieceGroupModel) -> Void)? = nil) {
        self.group = PieceGroupModel(index: index, pieces: pieces);
        self.onClick = onclick;
    }
    
    init(group: PieceGroupModel, onclick: ((PieceGroupModel) -> Void)? = nil) {
        self.group = group;
        self.onClick = onclick;
    }
}
