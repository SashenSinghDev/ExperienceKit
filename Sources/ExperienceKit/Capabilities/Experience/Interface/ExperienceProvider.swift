//
//  ExperienceDependancyContainer.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import Foundation

public struct ExperienceSession {
    public let interactor: ExperienceInteractor
    public let selectionStateStore: ExperienceSelectionStateStore?

    public init(interactor: ExperienceInteractor,
                selectionStateStore: ExperienceSelectionStateStore? = nil) {
        self.interactor = interactor
        self.selectionStateStore = selectionStateStore
    }
}

public protocol ExperienceProvider {
    func experienceSession(for id: ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceSession
}
