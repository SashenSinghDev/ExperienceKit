//
//  ScrollableInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class ScrollableInteractor: ExperienceInteractor {

    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(
            .scrollableWithNavigationProperties(components: exampleMocks, navigationBarModel: .init(title: "qwerty", displayMode: .automatic, searchBar: nil))
        )
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
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
