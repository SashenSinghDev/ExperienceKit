import Foundation

// sourcery: component = "animation"
public struct AnimationProperties {
    public let uri: String
    public let bundle: String
    public let width: Double?
    public let height: Double?
    public let loop: Bool

    public init(uri: String,
                bundle: String,
                width: Double? = nil,
                height: Double? = nil,
                loop: Bool = true) {
        self.uri = uri
        self.bundle = bundle
        self.width = width
        self.height = height
        self.loop = loop
    }
}

extension AnimationProperties: Properties, Codable {
    enum CodingKeys: String, CodingKey {
        case uri
        case bundle
        case width
        case height
        case loop
    }

    // `loop` is optional in payloads and defaults to a continuous loop.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uri = try container.decode(String.self, forKey: .uri)
        bundle = try container.decode(String.self, forKey: .bundle)
        width = try container.decodeIfPresent(Double.self, forKey: .width)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        loop = try container.decodeIfPresent(Bool.self, forKey: .loop) ?? true
    }

    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> AnimationProperties {
        return try properties.decode(AnimationProperties.self, forKey: .properties)
    }
}
