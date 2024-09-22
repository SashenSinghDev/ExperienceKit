//
//  ExampleComponentProviderService.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class ExampleComponentProviderService: ExperienceService {
    func load(completion: @escaping ([Component]) -> Void) {
        completion([
            Component(contentType: "exampleComponent",
                      properties: ExampleProperties(title: "mockTitle",
                                                    navigationType: .deepdive),
                      id: UUID())
        ])
    }
}
