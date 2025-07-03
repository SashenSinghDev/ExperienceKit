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
    func returnExperienceInteractor(for id: String) -> ExperienceInteractor {
        guard let experience = Experience(rawValue: id) else {
            fatalError("Experience id \(id) not found")
        }

        switch experience {
        case .fullScreen:
            return FullScreenInteractor()
        case .scrollableScreen:
            return ScrollableInteractor()
        case .homeContainer:
            return HomeContainerInteractor()
        }
    }
}
