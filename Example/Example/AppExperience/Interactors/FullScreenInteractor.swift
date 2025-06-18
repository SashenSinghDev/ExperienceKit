//
//  FullScreenInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class FullScreenInteractor: ExperienceInteractor {

    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(
            .fullScreen(component: WelcomeProperties.mock)
        )
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}
