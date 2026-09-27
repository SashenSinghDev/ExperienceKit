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
    /// Focuses the field when it appears, independent of `state`. Use it to move
    /// the caret into a field that is also in the `.error` state.
    public let requestsFocus: Bool

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
                selectionKey: String? = nil,
                requestsFocus: Bool = false) {
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
        self.requestsFocus = requestsFocus
    }
}

extension TextFieldProperties: Properties, Codable {
    private enum CodingKeys: String, CodingKey {
        case state, isSecure, keyboardType, label, placeholder, value, leadingSystemImage,
             showsClearButton, unit, helperText, errorMessage, accessibilityLabel, selectionKey,
             requestsFocus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            state: try container.decodeIfPresent(State.self, forKey: .state) ?? .empty,
            isSecure: try container.decodeIfPresent(Bool.self, forKey: .isSecure) ?? false,
            keyboardType: try container.decodeIfPresent(KeyboardType.self, forKey: .keyboardType) ?? .standard,
            label: try container.decodeIfPresent(String.self, forKey: .label),
            placeholder: try container.decode(String.self, forKey: .placeholder),
            value: try container.decodeIfPresent(String.self, forKey: .value) ?? "",
            leadingSystemImage: try container.decodeIfPresent(String.self, forKey: .leadingSystemImage),
            showsClearButton: try container.decodeIfPresent(Bool.self, forKey: .showsClearButton) ?? true,
            unit: try container.decodeIfPresent(String.self, forKey: .unit),
            helperText: try container.decodeIfPresent(String.self, forKey: .helperText),
            errorMessage: try container.decodeIfPresent(String.self, forKey: .errorMessage),
            accessibilityLabel: try container.decodeIfPresent(String.self, forKey: .accessibilityLabel),
            selectionKey: try container.decodeIfPresent(String.self, forKey: .selectionKey),
            requestsFocus: try container.decodeIfPresent(Bool.self, forKey: .requestsFocus) ?? false
        )
    }

    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> TextFieldProperties {
        return try properties.decode(TextFieldProperties.self, forKey: .properties)
    }
}
