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

    let firstComponent = Component(contentType: "exampleComponent",
                                   properties: ExampleProperties(title: "mockTitle \(Int.random(in: 0...10))",
                                                                 profilePlaceholder: "Enter your bio",
                                                                 initialAmount: 3),
                                   id: UUID())

    var components1: [Component] {
        [firstComponent,
         Component(contentType: "exampleComponent",
                   properties: ExampleProperties(title: "mockTitle2",
                                                 profilePlaceholder: "Enter your bio",
                                                 initialAmount: 2),
                   id: UUID())]
    }

    var components2: [Component] {
        [firstComponent]
    }

    init(experienceService: ExperienceService) {
        self.experienceService = experienceService
    }

    func load(completion: @escaping ([Component]) -> Void) {
//        experienceService.load { components in

        let comps = Int.random(in: 0...1) == 0 ? components1 : components2
            completion(comps)
//        }
    }
}
