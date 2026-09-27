import Combine
import Foundation

public final class TextViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperienceSelectionStateStore & HasExperienceSelectionChanges
    
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
    
    public enum Alignment {
        case leading
        case center
        case trailing
    }
    
    public enum ForegroundStyle {
        case primary
        case secondary
        case tertiary
        case quaternary
        case error
    }

    public let id: UUID
    /// The text to show, or `nil` when a missing-selections list has emptied.
    @Published private(set) var title: String?
    let font: Font
    let weight: Weight
    let alignment: Alignment
    let foregroundStyle :ForegroundStyle

    private let template: String
    private let missingSelections: TextProperties.MissingSelections?
    private var remainingFields: [TextProperties.MissingSelections.Field]
    private let experienceSelectionStateStore: ExperienceSelectionStateStore?
    private var cancellables = Set<AnyCancellable>()

    public init(properties: TextProperties,
                dependency: Dependencies,
                id: UUID) {
        let store = dependency.experienceSelectionStateStore
        let remainingFields = properties.missingSelections?.fields
            .filter { !Self.hasValue(for: $0, in: store) } ?? []

        self.id = id
        self.font = properties.font.toFont
        self.weight = properties.weight.toWeight
        self.alignment = properties.alignment.toAlignment
        self.foregroundStyle = properties.foregroundStyle.toForegroundStyle
        self.template = properties.title
        self.missingSelections = properties.missingSelections
        self.remainingFields = remainingFields
        self.experienceSelectionStateStore = store
        self.title = Self.title(template: properties.title,
                                missingSelections: properties.missingSelections,
                                remainingFields: remainingFields)

        guard missingSelections != nil else {
            return
        }

        dependency.experienceSelectionChanges
            .sink { [weak self] key in
                self?.selectionDidChange(for: key)
            }
            .store(in: &cancellables)
    }

    /// Names only ever leave the list, matching the text field's error border.
    private func selectionDidChange(for key: String) {
        guard let field = remainingFields.first(where: { $0.selectionKey == key }),
              Self.hasValue(for: field, in: experienceSelectionStateStore) else {
            return
        }

        remainingFields.removeAll { $0 == field }
        title = Self.title(template: template,
                           missingSelections: missingSelections,
                           remainingFields: remainingFields)
    }

    private static func hasValue(for field: TextProperties.MissingSelections.Field,
                                 in store: ExperienceSelectionStateStore?) -> Bool {
        let value = store?.selectedValues(for: field.selectionKey).first ?? ""
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Plain text returns the template as is. With missing selections, `{fields}`
    /// becomes "height" / "height and age" / "weight, height and age".
    static func title(template: String,
                      missingSelections: TextProperties.MissingSelections?,
                      remainingFields: [TextProperties.MissingSelections.Field]) -> String? {
        guard let missingSelections else {
            return template
        }

        let names = remainingFields.map(\.name)
        guard let lastName = names.last else {
            return nil
        }

        let list = names.count == 1
            ? lastName
            : names.dropLast().joined(separator: ", ") + " \(missingSelections.conjunction) " + lastName

        return template.replacingOccurrences(of: "{fields}", with: list)
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

private extension TextProperties.Alignment {
    var toAlignment: TextViewModel.Alignment {
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

private extension TextProperties.ForegroundStyle {
    var toForegroundStyle: TextViewModel.ForegroundStyle {
        switch self {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .tertiary:
            return .tertiary
        case .quaternary:
            return .quaternary
        case .error:
            return .error
        }
    }
}
