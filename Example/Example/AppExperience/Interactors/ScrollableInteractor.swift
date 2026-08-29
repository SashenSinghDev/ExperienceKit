//
//  ScrollableInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class ScrollableInteractor: ExperienceInteractor {
    func performDeferredWork(workId: any ExperienceKit.DeferredWorkID, completion: @escaping (ExperienceKit.ExperienceType?) -> Void) {
        completion(nil)
    }
    
    var experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(
            .scrollable(components: exampleMocks)
        )
    }
}

extension ScrollableInteractor {
    var exampleMocks: [Component] {
        let exampleMockComponent = ExampleProperties.mock
        let exampleRandomMockComponent = ExampleProperties.radomisedMock
        return Int.random(in: 0...1) == 0 ? [exampleMockComponent] : [exampleMockComponent, exampleRandomMockComponent]
    }
}
