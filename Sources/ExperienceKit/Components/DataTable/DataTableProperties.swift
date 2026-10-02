import Foundation

// sourcery: component = "datatable"
public struct DataTableProperties {
    public struct Row: Equatable {
        /// Leading cell, for example "Mon".
        public let label: String
        /// Trailing cells, left to right. The last one is the emphasised total.
        public let values: [String]
        /// Shows the marker dot after the label for rows worth calling out.
        public let isMarked: Bool

        public init(label: String,
                    values: [String],
                    isMarked: Bool = false) {
            self.label = label
            self.values = values
            self.isMarked = isMarked
        }
    }

    /// Header titles, leading column first. `nil` hides the header.
    public let columns: [String]?
    public let rows: [Row]
    /// Key under the card saying what the marker dot means. `nil` hides it.
    public let markerLabel: String?

    public init(columns: [String]?,
                rows: [Row],
                markerLabel: String? = nil) {
        self.columns = columns
        self.rows = rows
        self.markerLabel = markerLabel
    }
}

extension DataTableProperties.Row: Codable {
    enum CodingKeys: String, CodingKey {
        case label
        case values
        case isMarked
    }

    // `isMarked` is optional in payloads so unmarked rows can leave it out.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        values = try container.decode([String].self, forKey: .values)
        isMarked = try container.decodeIfPresent(Bool.self, forKey: .isMarked) ?? false
    }
}

extension DataTableProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> DataTableProperties {
        return try properties.decode(DataTableProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension DataTableProperties {
    static var mock: Component {
        Component(contentType: "datatable",
                  properties: DataTableProperties(columns: ["Day", "Fat", "Carbs", "Prot", "Cals"],
                                                  rows: [
                                                    .init(label: "Mon", values: ["60g", "345g", "210g", "2,775"], isMarked: true),
                                                    .init(label: "Tue", values: ["55g", "195g", "170g", "1,942"]),
                                                    .init(label: "Wed", values: ["55g", "195g", "170g", "1,942"])
                                                  ],
                                                  markerLabel: "High-carb day"),
                  id: UUID())
    }
}
#endif
