import Foundation

// sourcery: component = "image"
public struct ImageProperties {
    public let uri: String
    public let bundle: String
    public let width: Double?
    public let height: Double?

    public init(uri: String,
                bundle: String,
                width: Double? = nil,
                height: Double? = nil) {
        self.uri = uri
        self.bundle = bundle
        self.width = width
        self.height = height
    }
}

extension ImageProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ImageProperties {
        return try properties.decode(ImageProperties.self, forKey: .properties)
    }
}
