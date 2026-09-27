import XCTest
@testable import ExperienceKit

final class ButtonViewModelTests: XCTestCase {
    func testMapsTitleAndStyleFromProperties() {
        let viewModel = makeViewModel(title: "Continue", style: .glass)

        XCTAssertEqual(viewModel.title, "Continue")
        XCTAssertEqual(viewModel.style, .glass)
    }

    func testKeepsEachSupportedStyle() {
        let styles: [ButtonProperties.Style] = [.primary, .secondary, .borderless, .glass, .glassProminent]

        XCTAssertEqual(styles.map { makeViewModel(style: $0).style }, styles)
    }

    func testGlassStyleRoundTripsThroughCodable() throws {
        let properties = ButtonProperties(title: "Glass",
                                          style: .glass,
                                          navigation: .init(navigationType: .pop,
                                                            deferredLoadingWorkId: nil,
                                                            experienceViewModel: nil))

        let data = try JSONEncoder().encode(properties)
        let decoded = try JSONDecoder().decode(ButtonProperties.self, from: data)

        XCTAssertEqual(decoded.style, .glass)
        XCTAssertEqual(decoded.title, "Glass")
    }

    func testGlassProminentStyleRoundTripsThroughCodable() throws {
        let properties = ButtonProperties(title: "Continue",
                                          style: .glassProminent,
                                          navigation: .init(navigationType: .pop,
                                                            deferredLoadingWorkId: nil,
                                                            experienceViewModel: nil))

        let data = try JSONEncoder().encode(properties)
        let decoded = try JSONDecoder().decode(ButtonProperties.self, from: data)

        XCTAssertEqual(decoded.style, .glassProminent)
    }

    private func makeViewModel(title: String = "Button Title",
                               style: ButtonProperties.Style) -> ButtonViewModel {
        ButtonViewModel(
            properties: .init(title: title,
                              style: style,
                              navigation: .init(navigationType: .pop,
                                                deferredLoadingWorkId: nil,
                                                experienceViewModel: nil)),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: ButtonTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                viewProvider: ViewProvider(supportedComponentRegisters: []),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: [])
            ),
            id: UUID()
        )
    }
}

private enum ButtonTestExperienceID: String, ExperienceID {
    case root
}
