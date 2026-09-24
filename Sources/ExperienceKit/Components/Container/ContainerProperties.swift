import Foundation

// sourcery: component = "container"
public struct ContainerProperties {
    public enum Spacing: Codable {
        case small
        case medium
        case large
    }

    public typealias VerticalSpacing = Spacing
    
    public let component: Component
    public let verticalSpacing: Spacing?
    public let horizontalSpacing: Spacing?

    public init(component: Component,
                verticalSpacing: Spacing? = nil,
                horizontalSpacing: Spacing? = nil) {
        self.component = component
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
    }
}

extension ContainerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ContainerProperties {
        return try properties.decode(ContainerProperties.self, forKey: .properties)
    }
}
