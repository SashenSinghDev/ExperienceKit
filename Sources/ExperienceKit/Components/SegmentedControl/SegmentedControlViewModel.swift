import Foundation

public final class SegmentedControlViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let options: [SegmentedControlProperties.Option]
    let accessibilityLabel: String
    @Published public private(set) var selectedValue: String

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
    }

    func select(_ option: SegmentedControlProperties.Option) {
        selectValue(option.value)
    }

    func selectValue(_ value: String) {
        guard options.contains(where: { $0.value == value }), selectedValue != value else {
            return
        }

        selectedValue = value
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
