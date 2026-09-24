//
//  NavigationCapabilityInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class NavigationCapabilityInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init( experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        let buttonExperience: ExperienceType  = {
            return .scrollable(components: [
                .sectiontitleComponent(properties: .init(title: "Present")),
                insetButton(.init(
                    title: "push without loading",
                    style: .primary,
                    navigation: .init(navigationType: .push(Experience.navigationCapability),
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetButton(.init(
                    title: "push with loading",
                    style: .primary,
                    navigation: .init(navigationType: .push(Experience.navigationCapability),
                                      deferredLoadingWorkId: DeferredWork.loadData,
                                      experienceViewModel: nil))
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetButton(.init(
                    title: "present modal",
                    style: .primary,
                    navigation: .init(navigationType: .modal(Experience.navigationCapability),
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .sectiontitleComponent(properties: .init(title: "Dismiss")),
                insetButton(.init(
                    title: "dismiss",
                    style: .primary,
                    navigation: .init(navigationType: .dismiss,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetButton(.init(
                    title: "pop",
                    style: .primary,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetButton(.init(
                    title: "pop to root",
                    style: .primary,
                    navigation: .init(navigationType: .popToRoot,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
            ])
        }()
    
        completion(buttonExperience)
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

    private func insetButton(_ properties: ButtonProperties) -> Component {
        .containerComponent(properties: .init(
            component: .buttonComponent(properties: properties),
            horizontalSpacing: .medium)
        )
    }
}

private enum DeferredWork: String, DeferredWorkID {
    case loadData
}
