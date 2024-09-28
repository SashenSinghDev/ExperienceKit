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
    var components: [Component] = [Component(contentType: "exampleComponent",
                                             properties: ExampleProperties(title: "mockTitle",
                                                                           profilePlaceholder: "Enter your bio",
                                                                           initialAmount: 1,
                                                                           navigationType: .deepdive),
                                             id: UUID()),
                                   Component(contentType: "exampleComponent",
                                             properties: ExampleProperties(title: "mockTitle2",
                                                                           profilePlaceholder: "Enter your bio",
                                                                           initialAmount: 1,
                                                                           navigationType: .deepdive),
                                             id: UUID())]

    init(experienceService: ExperienceService) {
        self.experienceService = experienceService
    }

    func load(completion: @escaping ([Component]) -> Void) {
//        experienceService.load { components in
            completion(components)
//        }
    }
}
