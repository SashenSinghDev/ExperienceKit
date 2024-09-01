//
//  PrefilledExperienceService.swift
//
//
//  Created by Sashen Singh on 08/08/2024.
//

import Foundation

public final class PrefilledExperienceService: ExperienceService {
    private let components: [Component]

    public init(components: [Component]) {
        self.components = components
    }

    public func load(completion: @escaping ([Component]) -> Void) {
        completion(components)
    }
}
