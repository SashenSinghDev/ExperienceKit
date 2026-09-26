import Foundation

public final class SegmentedControlViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperienceSelectionStateStore

    public let id: UUID
    let options: [SegmentedControlProperties.Option]
    let accessibilityLabel: String
    @Published public private(set) var selectedValue: String
    private let experienceSelectionStateStore: ExperienceSelectionStateStore

    public init(properties: SegmentedControlProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.options = Array(properties.options.prefix(4))
        self.accessibilityLabel = properties.accessibilityLabel ?? "Selection"
        self.selectedValue = Self.validatedSelectedValue(
            properties.selectedValue,
            options: self.options
        )
        self.experienceSelectionStateStore = dependency.experienceSelectionStateStore
        experienceSelectionStateStore.setSelectedValue(self.selectedValue, for: self.accessibilityLabel)
    }

    func select(_ option: SegmentedControlProperties.Option) {
        selectValue(option.value)
    }

    func selectValue(_ value: String) {
        guard options.contains(where: { $0.value == value }), selectedValue != value else {
            return
        }

        selectedValue = value
        experienceSelectionStateStore.setSelectedValue(value, for: accessibilityLabel)
    }

    func isSelected(_ option: SegmentedControlProperties.Option) -> Bool {
        selectedValue == option.value
    }

    private static func validatedSelectedValue(_ selectedValue: String,
                                               options: [SegmentedControlProperties.Option]) -> String {
        guard let fallbackValue = options.first?.value else {
            return selectedValue
        }

        return options.contains { $0.value == selectedValue } ? selectedValue : fallbackValue
    }
}
