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

    func testSelectValueSendsOnChangeWorkWithTheNewValue() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = makeViewModel(selectedValue: "one-way",
                                      onChangeWorkId: SegmentedControlTestWorkID.tripTypeChanged,
                                      delegate: delegate)

        viewModel.selectValue("return")

        XCTAssertEqual(delegate.deferredWork, [.init(workId: "tripTypeChanged", values: ["return"])])
    }

    func testCreatingTheViewModelSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()

        _ = makeViewModel(selectedValue: "one-way",
                          onChangeWorkId: SegmentedControlTestWorkID.tripTypeChanged,
                          delegate: delegate)

        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testSelectingTheCurrentValueSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = makeViewModel(selectedValue: "one-way",
                                      onChangeWorkId: SegmentedControlTestWorkID.tripTypeChanged,
                                      delegate: delegate)

        viewModel.selectValue("one-way")

        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testSelectValueWithoutOnChangeWorkIdSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = makeViewModel(selectedValue: "one-way", delegate: delegate)

        viewModel.selectValue("return")

        XCTAssertEqual(viewModel.selectedValue, "return")
        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testDecodesOnChangeWorkId() throws {
        let json = """
        {
            "options": [{ "label": "One way", "value": "one-way" }],
            "selectedValue": "one-way",
            "onChangeWorkId": "tripTypeChanged"
        }
        """

        let properties = try JSONDecoder().decode(SegmentedControlProperties.self, from: Data(json.utf8))

        XCTAssertEqual(properties.onChangeWorkId?.rawValue, "tripTypeChanged")
    }

    private func makeViewModel(options: [SegmentedControlProperties.Option] = [
        .init(label: "One way", value: "one-way"),
        .init(label: "Return", value: "return")
    ],
                               selectedValue: String,
                               onChangeWorkId: (any DeferredWorkID)? = nil,
                               delegate: ExperiencePresenterNotifierDelegate? = nil) -> SegmentedControlViewModel {
        let notifier = DefaultExperiencePresenterNotifier()
        notifier.delegate = delegate

        return SegmentedControlViewModel(
            properties: .init(options: options, selectedValue: selectedValue, onChangeWorkId: onChangeWorkId),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: SegmentedControlTestExperienceID.root),
                experiencePresenterNotifier: notifier,
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

private enum SegmentedControlTestWorkID: String, DeferredWorkID {
    case tripTypeChanged
}
