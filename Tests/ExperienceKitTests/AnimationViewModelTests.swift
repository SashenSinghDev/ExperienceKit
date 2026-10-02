import SwiftUI
import XCTest
@testable import ExperienceKit

final class AnimationViewModelTests: XCTestCase {
    func testCarriesPropertiesIntoRenderState() {
        let viewModel = makeViewModel(
            properties: .init(uri: "spinner", bundle: "com.example.app", width: 88, height: 44, loop: false),
            provider: nil
        )

        XCTAssertEqual(viewModel.animation, ExperienceAnimation(uri: "spinner", bundle: "com.example.app", loop: false))
        XCTAssertEqual(viewModel.width, 88)
        XCTAssertEqual(viewModel.height, 44)
    }

    func testLoopsAndLeavesSizeUnconstrainedByDefault() {
        let viewModel = makeViewModel(
            properties: .init(uri: "spinner", bundle: "com.example.app"),
            provider: nil
        )

        XCTAssertTrue(viewModel.animation.loop)
        XCTAssertNil(viewModel.width)
        XCTAssertNil(viewModel.height)
    }

    func testAsksProviderForTheAnimationView() {
        let provider = RecordingAnimationProvider(knownURIs: ["spinner"])
        let viewModel = makeViewModel(
            properties: .init(uri: "spinner", bundle: "com.example.app", loop: false),
            provider: provider
        )

        XCTAssertNotNil(viewModel.animationView())
        XCTAssertEqual(provider.requestedAnimations,
                       [ExperienceAnimation(uri: "spinner", bundle: "com.example.app", loop: false)])
    }

    func testReturnsNoViewWhenProviderDoesNotRecogniseAnimation() {
        let provider = RecordingAnimationProvider(knownURIs: ["spinner"])
        let viewModel = makeViewModel(
            properties: .init(uri: "unknown", bundle: "com.example.app"),
            provider: provider
        )

        XCTAssertNil(viewModel.animationView())
    }

    func testReturnsNoViewWithoutProvider() {
        let viewModel = makeViewModel(
            properties: .init(uri: "spinner", bundle: "com.example.app"),
            provider: nil
        )

        XCTAssertNil(viewModel.animationView())
    }

    func testDecodingDefaultsLoopToTrueWhenMissing() throws {
        let json = Data(#"{"uri":"spinner","bundle":"com.example.app","width":88}"#.utf8)

        let properties = try JSONDecoder().decode(AnimationProperties.self, from: json)

        XCTAssertEqual(properties.uri, "spinner")
        XCTAssertEqual(properties.bundle, "com.example.app")
        XCTAssertEqual(properties.width, 88)
        XCTAssertNil(properties.height)
        XCTAssertTrue(properties.loop)
    }

    func testDecodingKeepsExplicitLoopValue() throws {
        let json = Data(#"{"uri":"spinner","bundle":"com.example.app","loop":false}"#.utf8)

        let properties = try JSONDecoder().decode(AnimationProperties.self, from: json)

        XCTAssertFalse(properties.loop)
    }

    private func makeViewModel(properties: AnimationProperties,
                               provider: ExperienceAnimationProvider?) -> AnimationViewModel {
        AnimationViewModel(properties: properties,
                           dependency: AnimationDependency(experienceAnimationProvider: provider),
                           id: UUID())
    }
}

private struct AnimationDependency: HasExperienceAnimationProvider {
    let experienceAnimationProvider: ExperienceAnimationProvider?
}

private final class RecordingAnimationProvider: ExperienceAnimationProvider {
    private let knownURIs: Set<String>
    private(set) var requestedAnimations: [ExperienceAnimation] = []

    init(knownURIs: Set<String>) {
        self.knownURIs = knownURIs
    }

    func animationView(for animation: ExperienceAnimation) -> AnyView? {
        requestedAnimations.append(animation)
        guard knownURIs.contains(animation.uri) else { return nil }
        return AnyView(EmptyView())
    }
}
