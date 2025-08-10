import Foundation

// sourcery: component = "container"
public struct ContainerProperties {
    public let component: Component

    public init(component: Component) {
        self.component = component
    }
}

extension ContainerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ContainerProperties {
        return try properties.decode(ContainerProperties.self, forKey: .properties)
    }
}
