import Foundation

// sourcery: component = "horizontalstack"
public struct HorizontalStackProperties {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

extension HorizontalStackProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> HorizontalStackProperties {
        return try properties.decode(HorizontalStackProperties.self, forKey: .properties)
    }
}
