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
            return .scrollable(components: textComponents)
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

    private var textComponents: [Component] {
        let fonts: [(title: String, font: TextProperties.Font)] = [
            ("Large Title", .largeTitle),
            ("Title 1", .title1),
            ("Title 2", .title2),
            ("Title 3", .title3),
            ("Headline", .headline),
            ("Body", .body),
            ("Callout", .callout),
            ("Subheadline", .subheadline),
            ("Footnote", .footnote),
            ("Caption 1", .caption1),
            ("Caption 2", .caption2),
        ]

        let weights: [(title: String, weight: TextProperties.Weight)] = [
            ("Bold", .bold),
            ("Medium", .medium),
            ("Medium Italic", .mediumItalic),
            ("Regular", .regular),
            ("Regular Italic", .regularItalic),
            ("Semi Bold", .semibold),
            ("Semi Bold Italic", .semiboldItalic),
        ]

        return fonts.flatMap { font in
            weights.flatMap { weight in
                [
                    Component.textComponent(
                        properties: .init(
                            title: "\(font.title) \(weight.title)",
                            font: font.font,
                            weight: weight.weight
                        )
                    ),
                    Component.spacerComponent(properties: .init(size: .small))
                ]
            }
        }
    }
}

private enum DeferredWork: String, DeferredWorkID {
    case loadData
}
