import Foundation

public final class TextViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency
    
    public enum Font {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case body
        case callout
        case subheadline
        case footnote
        case caption1
        case caption2
    }
    
    public enum Weight {
        case regular
        case regularItalic
        case medium
        case mediumItalic
        case semibold
        case semiboldItalic
        case bold
    }

    public let id: UUID
    let title: String
    let font: Font
    let weight: Weight

    public init(properties: TextProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.font = properties.font.toFont
        self.weight = properties.weight.toWeight
    }
}

private extension TextProperties.Font {
    var toFont: TextViewModel.Font {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title1
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
            return .caption1
        case .caption2:
            return .caption2
        }
    }
}

private extension TextProperties.Weight {
    var toWeight: TextViewModel.Weight {
        switch self {
        case .regular:
            return .regular
        case .regularItalic:
            return .regularItalic
        case .medium:
            return .medium
        case .mediumItalic:
            return .mediumItalic
        case .semibold:
            return .semibold
        case .semiboldItalic:
            return .semiboldItalic
        case .bold:
            return .bold
        }
    }
}
