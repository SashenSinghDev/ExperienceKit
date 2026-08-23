//
//  WelcomeInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class WelcomeComponentInteractor: ExperienceInteractor {
    internal let navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init( navigationBarModel: ExperienceKit.NavigationBarModel?) {
        self.navigationBarModel = navigationBarModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        
        let welcomeProperties = WelcomeProperties(
            image: .init(uri: "welcome-image",
                         bundle: Bundle.main.bundleIdentifier ?? ""),
            description: .init(title: "Welcome to 👋 GymBru",
                               subtitle: "A personal trainer in your pocket",
                               style: .large(.inverted)),
            primaryButton: .init(title: "Log In",
                                 style: .secondary,
                                 isFullWidth: true,
                                 navigation: .init(navigationType: .popToRoot,
                                                   deferredLoadingWorkId: nil,
                                                   navigationBarModel: nil)),
            secondaryButton: .init(title: "Get Started",
                                   style: .primary,
                                   isFullWidth: true,
                                   navigation: .init(navigationType: .modal(Experience.welcomeComponent),
                                                     deferredLoadingWorkId: DeferredWork.loadData,
                                                     navigationBarModel: nil))
        )

        completion(
            .fullScreen(component: .init(contentType: "welcome", properties: welcomeProperties, id: UUID()))
        )
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
