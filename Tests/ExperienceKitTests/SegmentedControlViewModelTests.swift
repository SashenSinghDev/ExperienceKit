import XCTest
@testable import ExperienceKit

final class SegmentedControlViewModelTests: XCTestCase {
    func testUsesProvidedSelectedValueWhenItMatchesAnOption() {
        let viewModel = makeViewModel(selectedValue: "return")

        XCTAssertEqual(viewModel.selectedValue, "return")
    }

    func testFallsBackToFirstOptionWhenSelectedValueIsInvalid() {
        let viewModel = makeViewModel(selectedValue: "missing")

        XCTAssertEqual(viewModel.selectedValue, "one-way")
    }

    func testKeepsOnlyFirstFourOptions() {
        let viewModel = makeViewModel(
            options: [
                .init(label: "One", value: "one"),
                .init(label: "Two", value: "two"),
                .init(label: "Three", value: "three"),
                .init(label: "Four", value: "four"),
                .init(label: "Five", value: "five")
            ],
            selectedValue: "five"
        )

        XCTAssertEqual(viewModel.options.map(\.value), ["one", "two", "three", "four"])
        XCTAssertEqual(viewModel.selectedValue, "one")
    }

    func testSelectUpdatesPublishedSelectedValue() {
        let viewModel = makeViewModel(selectedValue: "one-way")

        viewModel.select(.init(label: "Return", value: "return"))

        XCTAssertEqual(viewModel.selectedValue, "return")
    }

    func testSelectValueUpdatesPublishedSelectedValue() {
        let viewModel = makeViewModel(selectedValue: "one-way")

        viewModel.selectValue("return")

        XCTAssertEqual(viewModel.selectedValue, "return")
    }

    private func makeViewModel(options: [SegmentedControlProperties.Option] = [
        .init(label: "One way", value: "one-way"),
        .init(label: "Return", value: "return")
    ],
                               selectedValue: String) -> SegmentedControlViewModel {
        SegmentedControlViewModel(
            properties: .init(options: options, selectedValue: selectedValue),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: SegmentedControlTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                viewProvider: ViewProvider(supportedComponentRegisters: []),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: [])
            ),
            id: UUID()
        )
    }
}

private enum SegmentedControlTestExperienceID: String, ExperienceID {
    case root
}
