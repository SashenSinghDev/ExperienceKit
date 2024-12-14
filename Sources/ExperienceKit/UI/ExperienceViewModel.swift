//
//  ExperienceViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 14/12/2024.
//

public struct ExperienceViewModel {
    public enum ExperienceCharacterType {
        case fullScreen
        case scrollable
    }

    let experienceCharacterType: ExperienceCharacterType

    public init(experienceCharacterType: ExperienceViewModel.ExperienceCharacterType) {
        self.experienceCharacterType = experienceCharacterType
    }
}
