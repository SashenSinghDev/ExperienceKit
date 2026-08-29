import Foundation

// sourcery: component = "fullscreen"
public struct FullScreenProperties {
    public enum HorizontalAlignment: Codable {
        case leading
        case center
        case trailing
    }

    public enum VerticalAlignment: Codable {
        case top
        case center
        case bottom
    }

    public let image: ExperienceImage?
    public let horizontalAlignment: HorizontalAlignment
    public let verticalAlignment: VerticalAlignment
    public let topComponents: [Component]
    public let middleComponents: [Component]
    public let bottomComponents: [Component]

    public init(image: ExperienceImage?,
                horizontalAlignment: HorizontalAlignment,
                verticalAlignment: VerticalAlignment,
                topComponents: [Component],
                middleComponents: [Component],
                bottomComponents: [Component]) {
        self.image = image
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.topComponents = topComponents
        self.middleComponents = middleComponents
        self.bottomComponents = bottomComponents
    }
}

extension FullScreenProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> FullScreenProperties {
        return try properties.decode(FullScreenProperties.self, forKey: .properties)
    }
}
