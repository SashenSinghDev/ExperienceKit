//
//  FullScreenComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class FullScreenComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        let fullScreenExperience: ExperienceType  = {
            let properties = FullScreenProperties(
                image: .init(uri: "welcome-image",
                             bundle: Bundle.main.bundleIdentifier ?? ""),
                topComponents: [
                    .buttonComponent(properties: .init(title: "buttonTitle",
                                                       style: .secondary,
                                                       isFullWidth: false,
                                                       navigation: .init(navigationType: .pop,
                                                                         deferredLoadingWorkId: nil,
                                                                         experienceViewModel: nil)))
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
                                                                         experienceViewModel: nil))),
                    .spacerComponent(properties: .init(size: .small)),
                    .buttonComponent(properties: .init(title: "buttonTitle",
                                                       style: .secondary,
                                                       isFullWidth: false,
                                                       navigation: .init(navigationType: .pop,
                                                                         deferredLoadingWorkId: nil,
                                                                         experienceViewModel: nil))),
                ]
            )
            return .fullScreen(component: .fullscreenComponent(properties: properties))
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
