//
//  ExperienceListInteractor.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import ExperienceKit
import SwiftUI

final class ExperienceListInteractor: ExperienceInteractor {
    func load(completion: @escaping (ExperienceType) -> Void) {
        let navigationBarModel = NavigationBarModel(title: "Experience Kit",
                                                    displayMode: .large,
                                                    searchBar: .init(placeholder: "components and capabilities"))

        completion(.scrollableWithNavigationProperties(components: [
            .sectionTitleComponent(title: "Components", showBottomBorder: false),
            .genericListItemComponent(title: "Welcome",
                                      navigation: .init(navigationType: .push(Experience.componentDetail.rawValue),
                                                        deferredLoadingWorkId: nil,
                                                        additionalProperties: ["componentTitle": "welcome"])),
            .genericListItemComponent(title: "Button",
                                      navigation: .init(navigationType: .push(Experience.componentDetail.rawValue),
                                                        deferredLoadingWorkId: nil,
                                                        additionalProperties: ["componentTitle": "button"]))
        ], navigationBarModel: navigationBarModel))
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}
