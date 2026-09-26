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

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
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
                            navigationType: .push(Experience.playground),
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil))
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
        completion(nil)
    }
}
