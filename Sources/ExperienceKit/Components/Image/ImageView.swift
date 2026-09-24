import SwiftUI

struct ImageView: ComponentView {
    @ObservedObject var viewModel: ImageViewModel

    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Image(viewModel.uri,
              bundle: .init(identifier: viewModel.bundle))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipped()
    }
}

extension ImageView {
    static func == (lhs: ImageView, rhs: ImageView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
