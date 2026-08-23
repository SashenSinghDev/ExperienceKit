//
//  ButtonComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 22/08/2026.
//

import ExperienceKit
import SwiftUI

final class ButtonComponentInteractor: ExperienceInteractor {
    internal let navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init( navigationBarModel: ExperienceKit.NavigationBarModel?) {
        self.navigationBarModel = navigationBarModel
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        let buttonExperience: ExperienceType  = {
            return .scrollable(components: [
                .sectiontitleComponent(properties: .init(title: "PrimaryButton", showBottomBorder: false)),
                .buttonComponent(properties: .init(
                    title: "PrimaryButton",
                    style: .primary,
                    isFullWidth: false,
                    navigation: .init(navigationType: .pop,
                                      deferredLoadingWorkId: nil,
                                      additionalProperties: nil,
                                      navigationBarModel: nil))
                ),
                .sectiontitleComponent(properties: .init(title: "SecondaryButton", showBottomBorder: false)),
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Secondary",
                        style: .secondary,
                        isFullWidth: false,
                        navigation: .init(navigationType: .pop,
                                          deferredLoadingWorkId: nil,
                                          additionalProperties: nil,
                                          navigationBarModel: nil))))
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
}
