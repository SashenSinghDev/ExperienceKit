//
//  NavigationCapabilityInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class NavigationCapabilityInteractor: ExperienceInteractor {
    internal let navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init( navigationBarModel: ExperienceKit.NavigationBarModel?) {
        self.navigationBarModel = navigationBarModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        let buttonExperience: ExperienceType  = {
            return .scrollable(components: [
                .sectiontitleComponent(properties: .init(title: "Present", showBottomBorder: true)),
                .buttonComponent(properties: .init(
                    title: "push without loading",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .push(Experience.navigationCapability),
                                      deferredLoadingWorkId: nil,
                                      navigationBarModel: nil))
                ),
                .buttonComponent(properties: .init(
                    title: "push with loading",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .push(Experience.navigationCapability),
                                      deferredLoadingWorkId: DeferredWork.loadData,
                                      navigationBarModel: nil))
                ),
                .buttonComponent(properties: .init(
                    title: "present modal",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .modal(Experience.navigationCapability),
                                      deferredLoadingWorkId: nil,
                                      navigationBarModel: nil))
                ),
                .sectiontitleComponent(properties: .init(title: "Dismiss", showBottomBorder: true)),
                .buttonComponent(properties: .init(
                    title: "dismiss",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .dismiss,
                                      deferredLoadingWorkId: nil,
                                      navigationBarModel: nil))
                ),
                .buttonComponent(properties: .init(
                    title: "pop",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      navigationBarModel: nil))
                ),
                .buttonComponent(properties: .init(
                    title: "pop to root",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .popToRoot,
                                      deferredLoadingWorkId: nil,
                                      navigationBarModel: nil))
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
}
