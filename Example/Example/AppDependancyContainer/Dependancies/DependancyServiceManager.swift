//
//  DependancyServiceManager.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyServiceManager {

    let componentProviderService: ComponentProviderService

    init() {
        componentProviderService = ExampleComponentProviderService()
    }
}

extension DependancyServiceManager: HasComponentProviderService {}
