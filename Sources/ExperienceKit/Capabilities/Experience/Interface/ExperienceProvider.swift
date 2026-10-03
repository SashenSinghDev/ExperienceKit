//
//  ExperienceDependancyContainer.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import Foundation

public struct ExperienceSession {
    public let interactor: ExperienceInteractor
    public let animationProvider: ExperienceAnimationProvider?

    public init(interactor: ExperienceInteractor,
                animationProvider: ExperienceAnimationProvider? = nil) {
        self.interactor = interactor
        self.animationProvider = animationProvider
    }
}

public protocol ExperienceProvider {
    func experienceSession(for id: ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceSession
}
