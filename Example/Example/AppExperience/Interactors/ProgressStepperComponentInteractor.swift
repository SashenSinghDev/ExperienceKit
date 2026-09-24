//
//  ProgressStepperComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 24/09/2026.
//

import ExperienceKit
import SwiftUI

final class ProgressStepperComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Three steps")),
            .spacerComponent(properties: .init(size: .medium)),
            insetProgressStepper(currentStep: 1),
            .spacerComponent(properties: .init(size: .large)),
            insetProgressStepper(currentStep: 2),
            .spacerComponent(properties: .init(size: .large)),
            insetProgressStepper(currentStep: 3),
            .spacerComponent(properties: .init(size: .medium)),
            .sectiontitleComponent(properties: .init(title: "Five steps")),
            .spacerComponent(properties: .init(size: .medium)),
            insetProgressStepper(currentStep: 3, totalSteps: 5),
            .spacerComponent(properties: .init(size: .large)),
            insetProgressStepper(currentStep: 5, totalSteps: 5)
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func insetProgressStepper(currentStep: Int, totalSteps: Int = 3) -> Component {
        .containerComponent(properties: .init(
            component: .progressstepperComponent(properties: .init(
                currentStep: currentStep,
                totalSteps: totalSteps
            )),
            horizontalSpacing: .medium)
        )
    }
}
