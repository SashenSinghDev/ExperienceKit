//
//  DefaultExperienceService.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DefaultExperienceService: ExperienceService {
    let exampleMockComponent = ExampleProperties.mock
    let exampleRandomMockComponent = ExampleProperties.radomisedMock

    func load(completion: @escaping ([Component]) -> Void) {
        completion(
            exampleMocks
        )
    }
}

extension DefaultExperienceService {
    var exampleMocks: [Component] {
        return Int.random(in: 0...1) == 0 ? [exampleMockComponent] : [exampleMockComponent, exampleRandomMockComponent]
    }
}
