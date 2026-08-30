import SwiftUI

struct SpacerView: ComponentView {
    @ObservedObject var viewModel: SpacerViewModel

    init(viewModel: SpacerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Color.clear
            .frame(height: viewModel.size.spacing)
    }
}

private extension SpacerViewModel.Size {
    var spacing: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 16
        case .large:
            return 32
        }
    }
}

extension SpacerView {
    static func == (lhs: SpacerView, rhs: SpacerView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
