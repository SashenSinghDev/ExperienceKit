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

    func load(completion: @escaping ([Component]) -> Void) {
        completion(
            [WelcomeProperties.mock]
        )
    }
}
