//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit
import SwiftUI

final class AppExperienceProvider: ExperienceProvider {
    func returnExperienceInteractor(for id: any ExperienceID, navigationBarModel: NavigationBarModel?) -> ExperienceInteractor {
        guard let experience = Experience(rawValue: id.rawValue) else {
            fatalError("Experience id \(id.rawValue) not found")
        }

        switch experience {
        case .welcomeComponent:
            return WelcomeComponentInteractor(navigationBarModel: navigationBarModel)
        case .scrollableScreen:
            return ScrollableInteractor()
        case .experienceList: 
            return ExperienceListInteractor(navigationBarModel: navigationBarModel)
        case .buttonComponent:
            return ButtonComponentInteractor(navigationBarModel: navigationBarModel)
        case .fullScreenComponent:
            return FullScreenComponentInteractor(navigationBarModel: navigationBarModel)
        case .navigationCapability:
            return NavigationCapabilityInteractor(navigationBarModel: navigationBarModel)
        }
    }
}
