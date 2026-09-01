import SwiftUI

struct TextView: ComponentView {
    @ObservedObject var viewModel: TextViewModel

    init(viewModel: TextViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("\(viewModel.title)")
            .font(viewModel.font.swiftUIFont.weight(viewModel.weight.swiftUIFontWeight))
            .italic(viewModel.weight.isItalic)
            .multilineTextAlignment(viewModel.alignment.swiftUITextAlignment)
            .foregroundStyle(viewModel.foregroundStyle.swiftUIForegroundStyle)
    }
}

extension TextView {
    static func == (lhs: TextView, rhs: TextView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
}

private extension TextViewModel.Alignment {
    var swiftUITextAlignment: TextAlignment {
        switch self {
        case .center:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

private extension TextViewModel.ForegroundStyle {
    var swiftUIForegroundStyle: HierarchicalShapeStyle {
        switch self {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .tertiary:
            return .tertiary
        case .quaternary:
            return .quaternary
        }
    }
}

private extension TextViewModel.Font {
    var swiftUIFont: Font {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption1:
            return .caption
        case .caption2:
            return .caption2
        }
    }
}

private extension TextViewModel.Weight {
    var swiftUIFontWeight: Font.Weight {
        switch self {
        case .regular, .regularItalic:
            return .regular
        case .medium, .mediumItalic:
            return .medium
        case .semibold, .semiboldItalic:
            return .semibold
        case .bold:
            return .bold
        }
    }

    var isItalic: Bool {
        switch self {
        case .regularItalic, .mediumItalic, .semiboldItalic:
            return true
        case .regular, .medium, .semibold, .bold:
            return false
        }
    }
}
