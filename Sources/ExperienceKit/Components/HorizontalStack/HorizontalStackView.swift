import SwiftUI

struct HorizontalStackView: ComponentView {
    @ObservedObject var viewModel: HorizontalStackViewModel

    init(viewModel: HorizontalStackViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        switch viewModel.distribution {
        case .fillEqually, .leading:
            row
                .padding(.horizontal, viewModel.contentInset)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .scrollable:
            ScrollView(.horizontal, showsIndicators: false) {
                row
                    .scrollTargetLayout()
            }
            .contentMargins(.horizontal, viewModel.contentInset, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
    }

    private var row: some View {
        HStack(alignment: viewModel.alignment.verticalAlignment, spacing: viewModel.spacing) {
            ForEach(viewModel.children) { child in
                childView(for: child)
            }

            if viewModel.distribution == .leading {
                Spacer(minLength: .spacing.none)
            }
        }
    }

    @ViewBuilder
    private func childView(for child: AnyComponentViewModel) -> some View {
        switch viewModel.distribution {
        case .fillEqually:
            viewModel.viewProvider.view(for: child)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .leading, .scrollable:
            if let itemWidth = viewModel.itemWidth {
                viewModel.viewProvider.view(for: child)
                    .frame(width: itemWidth, alignment: .leading)
            } else {
                viewModel.viewProvider.view(for: child)
                    .fixedSize(horizontal: true, vertical: false)
            }
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
