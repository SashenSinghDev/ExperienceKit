import Foundation

// sourcery: component = "horizontalcontainer"
public struct HorizontalContainerProperties {
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
        /// Children keep their natural (or `itemWidth`) width and scroll
        /// horizontally, snapping to each child, e.g. a card carousel.
        case scrollable
    }

    public let components: [Component]
    public let spacing: Spacing
    public let alignment: Alignment
    public let distribution: Distribution
    /// Horizontal inset before the first and after the last child. For
    /// `.scrollable` rows this is a scroll content margin, so children line up
    /// with the page margin at rest but scroll edge to edge. Place scrollable
    /// rows directly in the screen, not inside a container with horizontal spacing.
    public let contentInset: Spacing
    /// Optional fixed width, in points, applied to every child. Leave `nil` when
    /// children size themselves (for example cards that set their own width).
    public let itemWidth: Double?

    public init(components: [Component],
                spacing: Spacing = .small,
                alignment: Alignment = .top,
                distribution: Distribution = .fillEqually,
                contentInset: Spacing = .none,
                itemWidth: Double? = nil) {
        self.components = components
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.contentInset = contentInset
        self.itemWidth = itemWidth
    }
}

extension HorizontalContainerProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> HorizontalContainerProperties {
        return try properties.decode(HorizontalContainerProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension HorizontalContainerProperties {
    static var mock: Component {
        Component(contentType: "horizontalcontainer",
                  properties: HorizontalContainerProperties(
                    components: [
                        .textComponent(properties: .init(title: "One", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary)),
                        .textComponent(properties: .init(title: "Two", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary)),
                        .textComponent(properties: .init(title: "Three", font: .body, weight: .regular, alignment: .leading, foregroundStyle: .primary))
                    ]),
                  id: UUID())
    }
}
#endif
