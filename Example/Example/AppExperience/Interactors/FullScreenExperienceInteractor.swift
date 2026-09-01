//
//  FullScreenExperienceInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class FullScreenExperienceInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        let fullScreenExperience: ExperienceType  = {
            let properties = FullScreenProperties(
//                image: .init(uri: "welcome_image",
//                             bundle: Bundle.main.bundleIdentifier ?? ""),
                image: nil,
                topComponents: [
                    .spacerComponent(properties: .init(size: .medium)),
                    .textComponent(properties: .init(
                        title: "Want want you to try our app for free",
                        font: .title1,
                        weight: .bold,
                        alignment: .center,
                        foregroundStyle: .primary)
                    )
                ],
                middleComponents: [
                    .buttonComponent(properties: .init(title: "buttonTitle",
                                                       style: .secondary,
                                                       isFullWidth: false,
                                                       navigation: .init(navigationType: .pop,
                                                                         deferredLoadingWorkId: nil,
                                                                         experienceViewModel: nil))),
                    .spacerComponent(properties: .init(size: .small)),
                    .buttonComponent(properties: .init(title: "buttonTitle",
                                                       style: .secondary,
                                                       isFullWidth: false,
                                                       navigation: .init(navigationType: .pop,
                                                                         deferredLoadingWorkId: nil,
                                                                         experienceViewModel: nil)))
                ],
                bottomComponents: [
                    .textComponent(properties: .init(
                        title: "✓ No payment due now",
                        font: .subheadline,
                        weight: .semibold,
                        alignment: .center,
                        foregroundStyle: .primary)
                    ),
                    .spacerComponent(properties: .init(size: .medium)),
                    .buttonComponent(properties: .init(
                        title: "Try for $0.00",
                        style: .primary,
                        isFullWidth: false,
                        navigation: .init(
                            navigationType: .push(Experience.fullScreen),
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil))
                    ),
                    .spacerComponent(properties: .init(size: .medium)),
                    .textComponent(properties: .init(
                        title: "Just $29.99 per year ($2.49/mo)",
                        font: .footnote,
                        weight: .regular,
                        alignment: .center,
                        foregroundStyle: .secondary))
                ]
            )
            return .fullScreen(properties: properties)
        }()
    
        completion(fullScreenExperience)
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(rawValue: workId.rawValue) else {
            completion(nil)
            return
        }

        performDeferredWork(deferredWork, completion: completion)
    }

    private func performDeferredWork(_ deferredWork: DeferredWork, completion: @escaping (ExperienceType?) -> Void) {
        switch deferredWork {
        case .loadData:
            loadData(completion: completion)
        }
    }

    private func loadData(completion: @escaping (ExperienceType?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(nil)
        }
    }
}

private enum DeferredWork: String, DeferredWorkID {
    case loadData
}
