import Foundation

// sourcery: component = "horizontalstack"
public struct HorizontalStackProperties {
    public enum Spacing: Codable {
        case none
        case small
        case medium
        case large
    }

    public enum Alignment: Codable {
        case top
        case center
        case bottom
    }

    public enum Distribution: Codable {
        /// Every child gets an equal share of the available width.
        case fillEqually
        /// Children keep their natural width and sit at the leading edge.
        case leading
    }

    public let components: [Component]
    public let spacing: Spacing
    public let alignment: Alignment
    public let distribution: Distribution

    public init(components: [Component],
                spacing: Spacing = .small,
                alignment: Alignment = .top,
                distribution: Distribution = .fillEqually) {
        self.components = components
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

extension HorizontalStackProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> HorizontalStackProperties {
        return try properties.decode(HorizontalStackProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension HorizontalStackProperties {
    static var mock: Component {
        Component(contentType: "horizontalstack",
                  properties: HorizontalStackProperties(
                    components: [
                        .textComponent(properties: .init(title: "One", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary)),
                        .textComponent(properties: .init(title: "Two", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary)),
                        .textComponent(properties: .init(title: "Three", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary))
                    ]),
                  id: UUID())
    }
}
#endif
