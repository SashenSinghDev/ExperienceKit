//
//  ButtonComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class ButtonComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        let buttonExperience: ExperienceType  = {
            return .scrollable(components: [
                .sectiontitleComponent(properties: .init(title: "PrimaryButton")),
                insetButton(.init(
                    title: "PrimaryButton",
                    style: .primary,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .sectiontitleComponent(properties: .init(title: "SecondaryButton")),
                insetButton(.init(
                    title: "SecondaryButton",
                    style: .secondary,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                ),
                .sectiontitleComponent(properties: .init(title: "BorderlessButton")),
                insetButton(.init(
                    title: "BorderlessButton",
                    style: .borderless,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      experienceViewModel: nil))
                )
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
