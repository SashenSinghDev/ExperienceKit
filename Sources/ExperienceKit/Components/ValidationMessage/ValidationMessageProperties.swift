import Foundation

// sourcery: component = "validationmessage"
/// A form-level error message that lists the fields still needing a value, e.g.
/// "Add your height and age to continue." Each field drops out of the list once a
/// value is entered for its selection key, and the message hides when none remain.
public struct ValidationMessageProperties {
    public struct Field: Codable, Equatable {
        /// How the field is named inside the message, e.g. "height".
        public let name: String
        /// The selection key the field's component writes to.
        public let selectionKey: String

        public init(name: String, selectionKey: String) {
            self.name = name
            self.selectionKey = selectionKey
        }
    }

    /// The fields that failed validation when the screen was submitted, in display order.
    public let fields: [Field]
    /// The message text, where `{fields}` is replaced by the remaining field names.
    public let template: String
    /// Joins the last two field names, e.g. "height and age".
    public let conjunction: String

    public init(fields: [Field],
                template: String,
                conjunction: String = "and") {
        self.fields = fields
        self.template = template
        self.conjunction = conjunction
    }
}

extension ValidationMessageProperties: Properties, Codable {
    private enum CodingKeys: String, CodingKey {
        case fields, template, conjunction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            fields: try container.decode([Field].self, forKey: .fields),
            template: try container.decode(String.self, forKey: .template),
            conjunction: try container.decodeIfPresent(String.self, forKey: .conjunction) ?? "and"
        )
    }

    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ValidationMessageProperties {
        return try properties.decode(ValidationMessageProperties.self, forKey: .properties)
    }
}
