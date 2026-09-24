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
        .frame(width: width,
               height: height)
        .clipped()
    }

    private var width: CGFloat? {
        guard let width = viewModel.width else { return nil }
        return CGFloat(width)
    }

    private var height: CGFloat? {
        guard let height = viewModel.height else { return nil }
        return CGFloat(height)
    }
}

extension ImageView {
    static func == (lhs: ImageView, rhs: ImageView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
