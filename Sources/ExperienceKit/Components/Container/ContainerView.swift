import SwiftUI

struct ContainerView: ComponentView {
    @ObservedObject var viewModel: ContainerViewModel

    init(viewModel: ContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        makeView(from: viewModel.anyComponentViewModel)
            .padding(.vertical, viewModel.verticalSpacing?.value ?? .spacing.none)
            .padding(.horizontal, viewModel.horizontalSpacing?.value ?? .spacing.none)
            .frame(maxWidth: .infinity, alignment: viewModel.alignment?.swiftUIAlignment ?? .center)
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

private extension ContainerViewModel.Alignment {
    var swiftUIAlignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
}
