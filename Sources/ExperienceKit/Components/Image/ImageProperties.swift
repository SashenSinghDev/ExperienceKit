import Foundation

// sourcery: component = "image"
public struct ImageProperties {
    public let uri: String
    public let bundle: String

    public init(uri: String,
                bundle: String) {
        self.uri = uri
        self.bundle = bundle
    }
}

extension ImageProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ImageProperties {
        return try properties.decode(ImageProperties.self, forKey: .properties)
    }
}
