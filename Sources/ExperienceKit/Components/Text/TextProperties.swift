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
    
    public enum ForegroundStyle: Codable {
        case primary
        case secondary
        case tertiary
        case quaternary
        /// Figma: color/accents/red — validation and error messages.
        case error
    }
    
    /// Turns the text into a live list of fields that still need a value, e.g. a
    /// form error such as "Add your height and age to continue." `title` is the
    /// template and `{fields}` in it is replaced by the names still missing. A name
    /// drops out once its selection key has a value, and the text hides when none
    /// remain. Names never come back; the next submit rebuilds the text.
    public struct MissingSelections: Codable, Equatable {
        public struct Field: Codable, Equatable {
            /// How the field is named inside the text, e.g. "height".
            public let name: String
            /// The selection key the field's component writes to.
            public let selectionKey: String

            public init(name: String, selectionKey: String) {
                self.name = name
                self.selectionKey = selectionKey
            }
        }

        public let fields: [Field]
        /// Joins the last two names, e.g. "height and age".
        public let conjunction: String

        public init(fields: [Field], conjunction: String = "and") {
            self.fields = fields
            self.conjunction = conjunction
        }
    }

    public let title: String
    public let font: Font
    public let weight: Weight
    public let alignment: Alignment
    public let foregroundStyle: ForegroundStyle
    public let missingSelections: MissingSelections?

    public init(title: String,
                font: Font,
                weight: Weight,
                alignment: Alignment,
                foregroundStyle: ForegroundStyle,
                missingSelections: MissingSelections? = nil) {
        self.title = title
        self.font = font
        self.weight = weight
        self.alignment = alignment
        self.foregroundStyle = foregroundStyle
        self.missingSelections = missingSelections
    }
}

extension TextProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> TextProperties {
        return try properties.decode(TextProperties.self, forKey: .properties)
    }
}
