import XCTest
@testable import ExperienceKit

final class ProgressStepperViewModelTests: XCTestCase {
    func testDefaultsToThreeTotalSteps() {
        let viewModel = makeViewModel(currentStep: 2)

        XCTAssertEqual(viewModel.currentStep, 2)
        XCTAssertEqual(viewModel.totalSteps, 3)
    }

    func testClampsCurrentStepBelowZeroToZero() {
        let viewModel = makeViewModel(currentStep: -1)

        XCTAssertEqual(viewModel.currentStep, 0)
        XCTAssertEqual(viewModel.totalSteps, 3)
    }

    func testClampsCurrentStepAboveTotalStepsToTotalSteps() {
        let viewModel = makeViewModel(currentStep: 9, totalSteps: 4)

        XCTAssertEqual(viewModel.currentStep, 4)
        XCTAssertEqual(viewModel.totalSteps, 4)
    }

    func testClampsTotalStepsToAtLeastOne() {
        let viewModel = makeViewModel(currentStep: 3, totalSteps: 0)

        XCTAssertEqual(viewModel.currentStep, 1)
        XCTAssertEqual(viewModel.totalSteps, 1)
    }

    private func makeViewModel(currentStep: Int, totalSteps: Int = 3) -> ProgressStepperViewModel {
        ProgressStepperViewModel(
            properties: .init(currentStep: currentStep, totalSteps: totalSteps),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: ProgressStepperTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                viewProvider: ViewProvider(supportedComponentRegisters: []),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: [])
            ),
            id: UUID()
        )
    }
}

private enum ProgressStepperTestExperienceID: String, ExperienceID {
    case root
}
