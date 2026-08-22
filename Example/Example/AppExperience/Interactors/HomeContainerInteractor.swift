//
//  HomeContainer.swift
//  Example
//
//  Created by Sashen Singh on 28/06/2025.
//

import ExperienceKit
import SwiftUI

final class HomeContainerInteractor: ExperienceInteractor {
    var navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {

        // check stored values
        completion(
            .navigateImmediately(navigationViewModel: NavigationViewModel(navigationType: .modal(Experience.welcomeComponent), deferredLoadingWorkId: nil, properties: nil))
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let descriptionComponent = Component(contentType: "descriptionComponent",
                                                 properties: DescriptionProperties(title: "randomTitle", subtitle: "randomSubtitle", style: .regular(.regular)),
                                                 id: UUID())

            completion(
                .scrollable(components: [descriptionComponent])
            )
        }
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(nil)
        }
    }
}
