import Foundation

public final class DataTableViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    struct Cell: Equatable {
        let text: String
        /// The last value column is the emphasised total.
        let isEmphasised: Bool
    }

    struct Header: Equatable {
        let label: String
        let values: [String]
    }

    struct Row: Equatable, Identifiable {
        let id: Int
        let label: String
        let cells: [Cell]
        let isMarked: Bool
        /// A hairline is drawn under every row except the last.
        let showsSeparator: Bool
        let accessibilityLabel: String
    }

    public let id: UUID
    /// `nil` when there are no column titles, which hides the header.
    let header: Header?
    let rows: [Row]
    /// `nil` hides the key under the card.
    let markerLabel: String?

    public init(properties: DataTableProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id

        let columns = properties.columns ?? []
        let headerValues = Array(columns.dropFirst())
        let markerLabel = properties.markerLabel.flatMap { $0.isEmpty ? nil : $0 }

        // Header and rows share one column grid, so short rows are padded with
        // empty cells to keep the figures lined up down the table.
        let valueColumnCount = max(headerValues.count,
                                   properties.rows.map(\.values.count).max() ?? 0)
        let paddedHeaderValues = Self.padded(headerValues, to: valueColumnCount)

        if let headerLabel = columns.first {
            self.header = Header(label: headerLabel, values: paddedHeaderValues)
        } else {
            self.header = nil
        }

        self.rows = properties.rows.enumerated().map { index, row in
            let values = Self.padded(row.values, to: valueColumnCount)

            return Row(id: index,
                       label: row.label,
                       cells: values.enumerated().map { valueIndex, value in
                           Cell(text: value, isEmphasised: valueIndex == valueColumnCount - 1)
                       },
                       isMarked: row.isMarked,
                       showsSeparator: index < properties.rows.count - 1,
                       accessibilityLabel: Self.accessibilityLabel(for: row,
                                                                   values: values,
                                                                   headerValues: paddedHeaderValues,
                                                                   markerLabel: markerLabel))
        }

        self.markerLabel = markerLabel
    }

    private static func padded(_ values: [String], to count: Int) -> [String] {
        values + Array(repeating: "", count: max(count - values.count, 0))
    }

    // Reads a row as one sentence: the label, what the marker means when the
    // row is marked, then each value paired with its column title.
    private static func accessibilityLabel(for row: DataTableProperties.Row,
                                           values: [String],
                                           headerValues: [String],
                                           markerLabel: String?) -> String {
        var parts = [row.label]

        if row.isMarked, let markerLabel {
            parts.append(markerLabel)
        }

        for (index, value) in values.enumerated() where !value.isEmpty {
            let title = headerValues[index]
            parts.append(title.isEmpty ? value : "\(title) \(value)")
        }

        return parts.joined(separator: ", ")
    }
}
