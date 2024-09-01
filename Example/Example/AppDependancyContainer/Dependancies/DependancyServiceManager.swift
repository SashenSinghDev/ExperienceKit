//
//  DependancyServiceManager.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyServiceManager {

    let experienceService: ExperienceService

    init() {
        experienceService = ExampleComponentProviderService()
    }
}

extension DependancyServiceManager: HasExperienceService {}
