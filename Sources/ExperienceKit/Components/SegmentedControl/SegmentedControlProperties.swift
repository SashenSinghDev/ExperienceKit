import Foundation

// sourcery: component = "segmentedcontrol"
public struct SegmentedControlProperties {
    public struct Option: Codable, Hashable {
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }

    public let options: [Option]
    public let selectedValue: String
    public let accessibilityLabel: String?

    public init(options: [Option],
                selectedValue: String,
                accessibilityLabel: String? = nil) {
        self.options = options
        self.selectedValue = selectedValue
        self.accessibilityLabel = accessibilityLabel
    }
}

extension SegmentedControlProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SegmentedControlProperties {
        return try properties.decode(SegmentedControlProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension SegmentedControlProperties {
    static var mock: Component {
        Component(contentType: "segmentedcontrol",
                  properties: SegmentedControlProperties(
                    options: [
                        .init(label: "One way", value: "one-way"),
                        .init(label: "Return", value: "return")
                    ],
                    selectedValue: "return",
                    accessibilityLabel: "Trip type"
                  ),
                  id: UUID())
    }
}
#endif
