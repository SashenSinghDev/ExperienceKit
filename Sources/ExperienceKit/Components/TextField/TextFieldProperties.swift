import Foundation

// sourcery: component = "textfield"
public struct TextFieldProperties {
    public enum State: Codable {
        case empty
        case filled
        case focused
        case error
        case disabled
    }

    public enum KeyboardType: Codable {
        case standard
        case emailAddress
        case numberPad
        case decimalPad
        case phonePad
    }

    public let state: State
    public let isSecure: Bool
    public let keyboardType: KeyboardType
    public let label: String?
    public let placeholder: String
    public let value: String
    public let leadingSystemImage: String?
    public let showsClearButton: Bool
    public let unit: String?
    public let helperText: String?
    public let errorMessage: String?
    public let accessibilityLabel: String?
    public let selectionKey: String?

    public init(state: State = .empty,
                isSecure: Bool = false,
                keyboardType: KeyboardType = .standard,
                label: String? = nil,
                placeholder: String,
                value: String = "",
                leadingSystemImage: String? = nil,
                showsClearButton: Bool = true,
                unit: String? = nil,
                helperText: String? = nil,
                errorMessage: String? = nil,
                accessibilityLabel: String? = nil,
                selectionKey: String? = nil) {
        self.state = state
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.leadingSystemImage = leadingSystemImage
        self.showsClearButton = showsClearButton
        self.unit = unit
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.accessibilityLabel = accessibilityLabel
        self.selectionKey = selectionKey
    }
}

extension TextFieldProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> TextFieldProperties {
        return try properties.decode(TextFieldProperties.self, forKey: .properties)
    }
}
