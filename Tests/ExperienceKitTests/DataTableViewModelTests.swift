import XCTest
@testable import ExperienceKit

final class DataTableViewModelTests: XCTestCase {
    func testSplitsColumnsIntoLeadingLabelAndValueTitles() {
        let viewModel = makeViewModel(columns: ["Day", "Fat", "Carbs", "Prot", "Cals"])

        XCTAssertEqual(viewModel.header,
                       DataTableViewModel.Header(label: "Day", values: ["Fat", "Carbs", "Prot", "Cals"]))
    }

    func testHidesHeaderWhenColumnsAreNilOrEmpty() {
        XCTAssertNil(makeViewModel(columns: nil).header)
        XCTAssertNil(makeViewModel(columns: []).header)
    }

    func testEmphasisesOnlyTheLastValue() {
        let viewModel = makeViewModel()

        XCTAssertEqual(viewModel.rows[0].cells.map(\.text), ["60g", "345g", "210g", "2,775"])
        XCTAssertEqual(viewModel.rows[0].cells.map(\.isEmphasised), [false, false, false, true])
    }

    func testShowsSeparatorUnderEveryRowExceptTheLast() {
        let viewModel = makeViewModel()

        XCTAssertEqual(viewModel.rows.map(\.showsSeparator), [true, false])
    }

    func testCarriesMarkedRows() {
        let viewModel = makeViewModel()

        XCTAssertEqual(viewModel.rows.map(\.isMarked), [true, false])
    }

    func testTreatsEmptyMarkerLabelAsAbsent() {
        XCTAssertEqual(makeViewModel(markerLabel: "High-carb day").markerLabel, "High-carb day")
        XCTAssertNil(makeViewModel(markerLabel: "").markerLabel)
        XCTAssertNil(makeViewModel(markerLabel: nil).markerLabel)
    }

    func testPadsShortRowsSoColumnsStayAligned() {
        let viewModel = makeViewModel(rows: [
            .init(label: "Mon", values: ["60g", "345g"]),
            .init(label: "Tue", values: ["55g", "195g", "170g", "1,942"])
        ])

        XCTAssertEqual(viewModel.rows[0].cells.map(\.text), ["60g", "345g", "", ""])
        XCTAssertEqual(viewModel.rows[1].cells.map(\.isEmphasised), [false, false, false, true])
    }

    func testAccessibilityLabelPairsValuesWithColumnTitlesAndExplainsMarker() {
        let viewModel = makeViewModel(markerLabel: "High-carb day")

        XCTAssertEqual(viewModel.rows[0].accessibilityLabel,
                       "Mon, High-carb day, Fat 60g, Carbs 345g, Prot 210g, Cals 2,775")
        XCTAssertEqual(viewModel.rows[1].accessibilityLabel,
                       "Tue, Fat 55g, Carbs 195g, Prot 170g, Cals 1,942")
    }

    func testAccessibilityLabelFallsBackToValuesWithoutHeader() {
        let viewModel = makeViewModel(columns: nil)

        XCTAssertEqual(viewModel.rows[1].accessibilityLabel, "Tue, 55g, 195g, 170g, 1,942")
    }

    func testDecodingDefaultsOptionalFields() throws {
        let json = """
        {
            "rows": [
                { "label": "Mon", "values": ["60g", "345g", "210g", "2,775"] }
            ]
        }
        """

        let properties = try JSONDecoder().decode(DataTableProperties.self, from: Data(json.utf8))

        XCTAssertNil(properties.columns)
        XCTAssertNil(properties.markerLabel)
        XCTAssertEqual(properties.rows, [.init(label: "Mon", values: ["60g", "345g", "210g", "2,775"])])
    }

    private func makeViewModel(columns: [String]? = ["Day", "Fat", "Carbs", "Prot", "Cals"],
                               rows: [DataTableProperties.Row] = [
                                .init(label: "Mon", values: ["60g", "345g", "210g", "2,775"], isMarked: true),
                                .init(label: "Tue", values: ["55g", "195g", "170g", "1,942"])
                               ],
                               markerLabel: String? = nil) -> DataTableViewModel {
        DataTableViewModel(
            properties: .init(columns: columns, rows: rows, markerLabel: markerLabel),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: DataTableTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                viewProvider: ViewProvider(supportedComponentRegisters: []),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: [])
            ),
            id: UUID()
        )
    }
}

private enum DataTableTestExperienceID: String, ExperienceID {
    case root
}
