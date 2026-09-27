import SwiftUI

struct HorizontalStackView: ComponentView {
    @ObservedObject var viewModel: HorizontalStackViewModel

    init(viewModel: HorizontalStackViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: viewModel.alignment.verticalAlignment, spacing: viewModel.spacing) {
            ForEach(viewModel.children) { child in
                childView(for: child)
            }

            if viewModel.distribution == .leading {
                Spacer(minLength: .spacing.none)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func childView(for child: AnyComponentViewModel) -> some View {
        switch viewModel.distribution {
        case .fillEqually:
            viewModel.viewProvider.view(for: child)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .leading:
            viewModel.viewProvider.view(for: child)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

extension HorizontalStackView {
    static func == (lhs: HorizontalStackView, rhs: HorizontalStackView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}

private extension HorizontalStackProperties.Alignment {
    var verticalAlignment: VerticalAlignment {
        switch self {
        case .top:
            return .top
        case .center:
            return .center
        case .bottom:
            return .bottom
        }
    }
}
