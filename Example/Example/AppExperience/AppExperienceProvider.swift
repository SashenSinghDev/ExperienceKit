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
    func returnExperienceInteractor(for id: any ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceInteractor {
        guard let experience = Experience(rawValue: id.rawValue) else {
            fatalError("Experience id \(id.rawValue) not found")
        }

        switch experience {
        case .welcomeComponent:
            return WelcomeComponentInteractor(experienceViewModel: experienceViewModel)
        case .scrollableScreen:
            return ScrollableInteractor()
        case .experienceList: 
            return ExperienceListInteractor(experienceViewModel: experienceViewModel)
        case .buttonComponent:
            return ButtonComponentInteractor(experienceViewModel: experienceViewModel)
        case .fullScreen:
            return FullScreenExperienceInteractor(experienceViewModel: experienceViewModel)
        case .navigationCapability:
            return NavigationCapabilityInteractor(experienceViewModel: experienceViewModel)
        case .textComponent:
            return TextComponentInteractor(experienceViewModel: experienceViewModel)
        }
    }
}
