//
//  HomeContainer.swift
//  Example
//
//  Created by Sashen Singh on 28/06/2025.
//

import ExperienceKit
import SwiftUI

final class HomeContainerInteractor: ExperienceInteractor {

    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {

        completion(
            .navigateImmediately(navigationViewModel: NavigationViewModel(navigationType: .modal("fullScreen"), deferredLoadingWorkId: nil))
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let descriptionComponent = Component(contentType: "descriptionComponent",
                                                 properties: DescriptionProperties(title: "randomTitle", subtitle: "randomSubtitle", style: .regular(.regular)),
                                                 id: UUID())

            completion(
                .scrollableWithNavigationProperties(components: [descriptionComponent], navigationBarModel: .init(title: "homeScreenLoaded", displayMode: .large))
            )
        }
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}
