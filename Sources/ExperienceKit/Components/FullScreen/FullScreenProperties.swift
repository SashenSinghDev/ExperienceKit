import Foundation

// sourcery: component = "fullscreen"
public struct FullScreenProperties {
    public let image: ExperienceImage?
    public let topComponents: [Component]
    public let middleComponents: [Component]
    public let bottomComponents: [Component]

    public init(image: ExperienceImage?,
                topComponents: [Component],
                middleComponents: [Component],
                bottomComponents: [Component]) {
        self.image = image
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
