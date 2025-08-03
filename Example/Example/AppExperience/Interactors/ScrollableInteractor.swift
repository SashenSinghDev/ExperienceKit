//
//  ScrollableInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class ScrollableInteractor: ExperienceInteractor {
    var navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(
            .scrollable(components: exampleMocks)
        )
    }

    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(nil)
        }
    }
}

extension ScrollableInteractor {
    var exampleMocks: [Component] {
        let exampleMockComponent = ExampleProperties.mock
        let exampleRandomMockComponent = ExampleProperties.radomisedMock
        return Int.random(in: 0...1) == 0 ? [exampleMockComponent] : [exampleMockComponent, exampleRandomMockComponent]
    }
}
