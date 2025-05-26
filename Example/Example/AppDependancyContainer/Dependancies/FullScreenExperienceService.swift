//
//  FullScreenExperienceService.swift
//  Example
//
//  Created by Sashen Singh on 14/12/2024.
//

import ExperienceKit

final class FullScreenExperienceService: ExperienceService {
    let exampleMockComponent = ExampleProperties.mock
    let exampleRandomMockComponent = ExampleProperties.radomisedMock

    init() {
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(
            .fullScreen(component: WelcomeProperties.mock)
        )
    }
}
