//
//  PlaygroundInteractor.swift
//  Example
//
//  Created by Sashen Singh on 24/09/2026.
//

import ExperienceKit
import Foundation

final class PlaygroundInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let mainBundleIdentifier = Bundle.main.bundleIdentifier ?? ""
    private let playgroundFlowSelectionStateStore: AppExperienceSelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         playgroundFlowSelectionStateStore: AppExperienceSelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.playgroundFlowSelectionStateStore = playgroundFlowSelectionStateStore
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [],
            middleComponents: [
            ],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .imageComponent(properties: .init(
                        uri: "circle_image",
                        bundle: mainBundleIdentifier,
                        width: 132,
                        height: 132)
                    ),
                    horizontalSpacing: .medium,
                    alignment: .leading)
                ),
                .spacerComponent(properties: .init(size: .medium)),
                .containerComponent(properties: .init(
                    component: .textComponent(properties: .init(
                        title: "Portionly",
                        font: .largeTitle,
                        weight: .bold,
                        alignment: .leading,
                        foregroundStyle: .primary)
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .medium)),
                .containerComponent(properties: .init(
                    component: .textComponent(properties: .init(
                        title: "A few quick questions and you'll have a week of macro targets built for your body. No food diary to fill in first.",
                        font: .body,
                        weight: .regular,
                        alignment: .leading,
                        foregroundStyle: .secondary)
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .large)),
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Build my plan",
                        style: .primary,
                        navigation: .init(
                            navigationType: .push(Experience.playgroundGoalUnits),
                            deferredLoadingWorkId: DeferredWork.buildMyPlan,
                            experienceViewModel: .init(
                                searchBar: nil,
                                navigationBar: nil)))
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .small)),
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "I already have an account",
                        style: .borderless,
                        navigation: .init(
                            navigationType: .dismiss,
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil))
                    ),
                    horizontalSpacing: .medium)
                ),
            ]
        )))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(rawValue: workId.rawValue) else {
            completion(nil)
            return
        }

        switch deferredWork {
        case .buildMyPlan:
            // A new run of the flow starts here, so drop values from any previous run.
            playgroundFlowSelectionStateStore.removeAllSelectedValues()
        }

        completion(nil)
    }
}

private extension PlaygroundInteractor {
    enum DeferredWork: String, DeferredWorkID {
        case buildMyPlan
    }
}
