import SwiftUI

struct ContainerView: ComponentView {
    @ObservedObject var viewModel: ContainerViewModel

    init(viewModel: ContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        makeView(from: viewModel.anyComponentViewModel)
            .padding(.vertical, 8)
            .background(.gray)
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewModel.viewProvider.view(for: component)
    }
}

extension ContainerView {
    static func == (lhs: ContainerView, rhs: ContainerView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}
