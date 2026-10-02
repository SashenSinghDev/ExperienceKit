import Foundation

public final class TextFieldViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperienceSelectionStateStore

    public let id: UUID
    let state: TextFieldProperties.State
    let isSecure: Bool
    let keyboardType: TextFieldProperties.KeyboardType
    let label: String?
    let placeholder: String
    let leadingSystemImage: String?
    let showsClearButton: Bool
    let unit: String?
    let accessibilityLabel: String
    let selectionKey: String
    let requestsFocus: Bool
    @Published var text: String
    private let helperText: String?
    private let errorMessage: String?
    private let experienceSelectionStateStore: ExperienceSelectionStateStore?

    public init(properties: TextFieldProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.state = properties.state
        self.isSecure = properties.isSecure
        self.keyboardType = properties.keyboardType
        self.label = properties.label
        self.placeholder = properties.placeholder
        self.leadingSystemImage = properties.leadingSystemImage
        self.showsClearButton = properties.showsClearButton
        self.unit = properties.unit
        self.helperText = properties.helperText
        self.errorMessage = properties.errorMessage
        self.accessibilityLabel = properties.accessibilityLabel ?? properties.label ?? properties.placeholder
        self.selectionKey = properties.selectionKey ?? properties.label ?? properties.placeholder
        self.requestsFocus = properties.requestsFocus && properties.state != .disabled
        self.text = properties.state == .empty ? "" : properties.value
        self.experienceSelectionStateStore = dependency.experienceSelectionStateStore
        experienceSelectionStateStore?.setSelectedValue(text, for: selectionKey)
    }

    var message: String? {
        state == .error ? errorMessage : helperText
    }

    var isDisabled: Bool {
        state == .disabled
    }

    var focusesOnAppear: Bool {
        state == .focused || requestsFocus
    }

    var showsError: Bool {
        state == .error
    }

    func updateText(_ text: String) {
        guard self.text != text else {
            return
        }

        self.text = text
        experienceSelectionStateStore?.setSelectedValue(text, for: selectionKey)
    }
}
