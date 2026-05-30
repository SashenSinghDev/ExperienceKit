//
//  ExperienceDependancyContainer.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import Foundation

public protocol ExperienceProvider {
    func returnExperienceInteractor(for id: ExperienceID, properties: [String: String]?) -> ExperienceInteractor
}
