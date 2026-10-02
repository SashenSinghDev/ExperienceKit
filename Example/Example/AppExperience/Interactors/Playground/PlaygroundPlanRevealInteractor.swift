//
//  PlaygroundPlanRevealInteractor.swift
//  Example
//
//  Created by Claude on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundPlanRevealInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    /// Placeholder for the plan reveal screen, which has no Figma implementation yet.
    /// It exists so the calculating screen has somewhere to move on to.
    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [],
            middleComponents: [
                centredText(
                    title: "Plan reveal",
                    font: .title2,
                    weight: .bold,
                    foregroundStyle: .primary
                ),
                .spacerComponent(properties: .init(size: .small)),
                centredText(
                    title: "Placeholder for the plan reveal screen.",
                    font: .subheadline,
                    weight: .regular,
                    foregroundStyle: .secondary
                )
            ],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Done",
                        style: .primary,
                        navigation: .init(
                            navigationType: .dismiss,
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil))
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .small))
            ]
        )))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func centredText(title: String,
                             font: TextProperties.Font,
                             weight: TextProperties.Weight,
                             foregroundStyle: TextProperties.ForegroundStyle) -> Component {
        .containerComponent(properties: .init(
            component: .textComponent(properties: .init(
                title: title,
                font: font,
                weight: weight,
                alignment: .center,
                foregroundStyle: foregroundStyle)
            ),
            horizontalSpacing: .large,
            alignment: .center)
        )
    }
}
