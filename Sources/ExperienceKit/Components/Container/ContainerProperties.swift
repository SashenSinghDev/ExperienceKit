import Foundation

// sourcery: component = "container"
public struct ContainerProperties {
    public enum VerticalSpacing: Codable {
        case small
        case medium
        case large
    }
    
    public let component: Component
    public let verticalSpacing: VerticalSpacing

    public init(component: Component,
                verticalSpacing: VerticalSpacing) {
        self.component = component
        self.verticalSpacing = verticalSpacing
    }
}

extension ContainerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ContainerProperties {
        return try properties.decode(ContainerProperties.self, forKey: .properties)
    }
}
