//
//  ExperienceDependancyContainer.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import Foundation

public protocol ExperienceProvider {
    func returnExperienceInteractor(for id: ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceInteractor
    func selectionStateStore(for id: ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceSelectionStateStore?
}

public extension ExperienceProvider {
    func selectionStateStore(for id: ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceSelectionStateStore? {
        nil
    }
}
