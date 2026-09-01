//
//  TextComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 01/09/2026.
//

import ExperienceKit
import SwiftUI

final class TextComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        let buttonExperience: ExperienceType  = {
            return .scrollable(components: [
                .textComponent(properties: .init(title: "Large Title Bold", font: .largeTitle, weight: .bold)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Large Title Medium", font: .largeTitle, weight: .medium)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Large Title Medium Italic", font: .largeTitle, weight: .mediumItalic)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Large Title Regular", font: .largeTitle, weight: .regular)),
                .textComponent(properties: .init(title: "Large Title Regular Italic", font: .largeTitle, weight: .regularItalic)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Large Title Semi Bold", font: .largeTitle, weight: .semibold)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Large Title Semi Bold Italic", font: .largeTitle, weight: .semiboldItalic)),
                .spacerComponent(properties: .init(size: .small)),
                .textComponent(properties: .init(title: "Title 1 Bold", font: .title1, weight: .bold)),
            ])
        }()
    
        completion(buttonExperience)
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(rawValue: workId.rawValue) else {
            completion(nil)
            return
        }

        performDeferredWork(deferredWork, completion: completion)
    }

    private func performDeferredWork(_ deferredWork: DeferredWork, completion: @escaping (ExperienceType?) -> Void) {
        switch deferredWork {
        case .loadData:
            loadData(completion: completion)
        }
    }

    private func loadData(completion: @escaping (ExperienceType?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(nil)
        }
    }
}

private enum DeferredWork: String, DeferredWorkID {
    case loadData
}
