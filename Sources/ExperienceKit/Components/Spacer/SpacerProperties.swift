import Foundation

// sourcery: component = "spacer"
public struct SpacerProperties {
    
    public enum Size: Codable {
        case small
        case medium
        case large
    }
    
    public let size: Size

    public init(size: Size) {
        self.size = size
    }
}

extension SpacerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SpacerProperties {
        return try properties.decode(SpacerProperties.self, forKey: .properties)
    }
}
