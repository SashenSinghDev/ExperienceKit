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
    func returnExperienceInteractor(for id: any ExperienceID, properties: [String: String]?) -> ExperienceInteractor {
        guard let experience = Experience(rawValue: id.rawValue) else {
            fatalError("Experience id \(id.rawValue) not found")
        }

        switch experience {
        case .welcomeComponent:
            return WelcomeComponentInteractor()
        case .scrollableScreen:
            return ScrollableInteractor()
        case .homeContainer:
            return HomeContainerInteractor()
        case .experienceList: 
            return ExperienceListInteractor()
        case .componentDetail:
            return ComponentDetailInteractor(properties: properties ?? [:])
        }
    }
}
