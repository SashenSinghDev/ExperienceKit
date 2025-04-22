//
//  ExperienceInteractor.swift
//  Example
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation
import ExperienceKit
import SwiftUI

final class ExampleExperienceInteractor: ExperienceInteractor {

    let experienceService: ExperienceService

    init(experienceService: ExperienceService) {
        self.experienceService = experienceService
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        experienceService.load { experienctType in
            completion(experienctType)
        }
    }
}
