import Foundation

// sourcery: component = "container"
public struct ContainerProperties {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

extension ContainerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ContainerProperties {
        return try properties.decode(ContainerProperties.self, forKey: .properties)
    }
}
