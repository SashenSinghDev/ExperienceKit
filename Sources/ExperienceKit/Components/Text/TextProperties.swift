import Foundation

// sourcery: component = "text"
public struct TextProperties {
    public enum Font: Codable {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case body
        case callout
        case subheadline
        case footnote
        case caption1
        case caption2
    }
    
    public enum Weight: Codable {
        case regular
        case regularItalic
        case medium
        case mediumItalic
        case semibold
        case semiboldItalic
        case bold
    }
    
    public enum Alignment: Codable {
        case leading
        case center
        case trailing
    }
    
    public let title: String
    public let font: Font
    public let weight: Weight
    public let alignment: Alignment

    public init(title: String,
                font: Font,
                weight: Weight,
                alignment: Alignment) {
        self.title = title
        self.font = font
        self.weight = weight
        self.alignment = alignment
    }
}

extension TextProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> TextProperties {
        return try properties.decode(TextProperties.self, forKey: .properties)
    }
}
