import XCTest
@testable import ExperienceKit

final class TextFieldViewModelTests: XCTestCase {
    func testEmptyStateIgnoresProvidedValue() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .empty,
                placeholder: "Email",
                value: "jordan@example.com"
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.text, "")
        XCTAssertFalse(viewModel.isDisabled)
    }

    func testErrorStateUsesErrorMessage() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .error,
                placeholder: "Email",
                value: "not-an-email",
                helperText: "Helper",
                errorMessage: "Enter a valid email address."
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.message, "Enter a valid email address.")
        XCTAssertTrue(viewModel.showsError)
    }

    func testTextUpdateSendsOnChangeWorkWithTheNewText() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .filled,
                placeholder: "Email",
                value: "jordan@example.com",
                onChangeWorkId: TextFieldTestWorkID.emailChanged
            ),
            dependency: TextFieldDependency(delegate: delegate),
            id: UUID()
        )

        viewModel.updateText("casey@example.com")

        XCTAssertEqual(viewModel.text, "casey@example.com")
        XCTAssertEqual(delegate.deferredWork, [.init(workId: "emailChanged", values: ["casey@example.com"])])
    }

    func testCreatingTheViewModelSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()

        _ = TextFieldViewModel(
            properties: .init(
                state: .filled,
                placeholder: "Email",
                value: "jordan@example.com",
                onChangeWorkId: TextFieldTestWorkID.emailChanged
            ),
            dependency: TextFieldDependency(delegate: delegate),
            id: UUID()
        )

        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testUnchangedTextSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .filled,
                placeholder: "Email",
                value: "jordan@example.com",
                onChangeWorkId: TextFieldTestWorkID.emailChanged
            ),
            dependency: TextFieldDependency(delegate: delegate),
            id: UUID()
        )

        viewModel.updateText("jordan@example.com")

        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testTextUpdateWithoutOnChangeWorkIdSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let viewModel = TextFieldViewModel(
            properties: .init(state: .filled, placeholder: "Email", value: "jordan@example.com"),
            dependency: TextFieldDependency(delegate: delegate),
            id: UUID()
        )

        viewModel.updateText("casey@example.com")

        XCTAssertEqual(viewModel.text, "casey@example.com")
        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testKeyboardTypeIsCarriedFromProperties() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .filled,
                keyboardType: .decimalPad,
                placeholder: "Weight",
                value: "93",
                unit: "kg"
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.keyboardType, .decimalPad)
    }

    func testClearButtonIsShownByDefault() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .focused,
                placeholder: "Search",
                value: "Coffee near me"
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertTrue(viewModel.showsClearButton)
    }

    func testClearButtonCanBeHidden() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .focused,
                placeholder: "Search",
                value: "Coffee near me",
                showsClearButton: false
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertFalse(viewModel.showsClearButton)
    }

    func testErrorStateCanRequestFocus() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .error,
                placeholder: "180",
                requestsFocus: true
            ),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertTrue(viewModel.showsError)
        XCTAssertTrue(viewModel.focusesOnAppear)
    }

    func testFocusIsNotRequestedByDefault() {
        let viewModel = TextFieldViewModel(
            properties: .init(state: .error, placeholder: "180"),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertFalse(viewModel.focusesOnAppear)
    }

    func testDisabledFieldIgnoresFocusRequest() {
        let viewModel = TextFieldViewModel(
            properties: .init(state: .disabled, placeholder: "180", requestsFocus: true),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertFalse(viewModel.focusesOnAppear)
    }

    func testErrorStateKeepsEnteredValue() {
        let viewModel = TextFieldViewModel(
            properties: .init(state: .error, placeholder: "88", value: "88"),
            dependency: TextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.text, "88")
    }

    func testDecodingDefaultsOmittedProperties() throws {
        let json = Data(#"{"placeholder": "Email"}"#.utf8)

        let properties = try JSONDecoder().decode(TextFieldProperties.self, from: json)

        XCTAssertEqual(properties.placeholder, "Email")
        XCTAssertEqual(properties.state, .empty)
        XCTAssertTrue(properties.showsClearButton)
        XCTAssertFalse(properties.requestsFocus)
        XCTAssertNil(properties.onChangeWorkId)
    }

    func testDecodesOnChangeWorkId() throws {
        let json = Data(#"{"placeholder": "Email", "onChangeWorkId": "emailChanged"}"#.utf8)

        let properties = try JSONDecoder().decode(TextFieldProperties.self, from: json)

        XCTAssertEqual(properties.onChangeWorkId?.rawValue, "emailChanged")
    }
}

private struct TextFieldDependency: HasExperiencePresenterNotifier {
    let experiencePresenterNotifier: ExperiencePresenterNotifier

    init(delegate: ExperiencePresenterNotifierDelegate? = nil) {
        let notifier = DefaultExperiencePresenterNotifier()
        notifier.delegate = delegate
        self.experiencePresenterNotifier = notifier
    }
}

private enum TextFieldTestWorkID: String, DeferredWorkID {
    case emailChanged
}
