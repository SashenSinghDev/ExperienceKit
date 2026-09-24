import Foundation

public final class ProgressStepperViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let currentStep: Int
    let totalSteps: Int

    public init(properties: ProgressStepperProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.totalSteps = max(properties.totalSteps, 1)
        self.currentStep = min(max(properties.currentStep, 0), self.totalSteps)
    }
}
