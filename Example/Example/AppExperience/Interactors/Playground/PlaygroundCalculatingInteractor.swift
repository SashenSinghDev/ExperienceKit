//
//  PlaygroundCalculatingInteractor.swift
//  Example
//
//  Created by Claude on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundCalculatingInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let experienceSelectionStateStore: ExperienceSelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         experienceSelectionStateStore: ExperienceSelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.experienceSelectionStateStore = experienceSelectionStateStore
    }

    /// Figma: 06 Calculating.
    func load(completion: @escaping (ExperienceType) -> Void) {
        // The message describes the split chosen on the previous screen.
        let selectedSplit = experienceSelectionStateStore.selectedValues(for: SelectionKey.weeklySplit).first
            .flatMap(WeeklySplit.init(rawValue:)) ?? .carbCycling

        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [],
            middleComponents: [
                .animationComponent(properties: .init(
                    uri: AppExperienceAnimationProvider.AnimationURI.spinner,
                    bundle: Bundle.main.bundleIdentifier ?? "",
                    width: Layout.spinnerSide,
                    height: Layout.spinnerSide,
                    loop: true)
                ),
                .spacerComponent(properties: .init(size: .medium)),
                centredText(
                    title: "Working out your week",
                    font: .title2,
                    weight: .bold,
                    foregroundStyle: .primary,
                    insets: [.large]
                ),
                .spacerComponent(properties: .init(size: .medium)),
                .spacerComponent(properties: .init(size: .small)),
                // Figma keeps the message to a narrow 246pt column, so it is inset
                // further than the title.
                centredText(
                    title: selectedSplit.calculatingMessage,
                    font: .subheadline,
                    weight: .regular,
                    foregroundStyle: .secondary,
                    insets: [.large, .large, .medium]
                )
            ],
            bottomComponents: []
        )))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        // The screen has no actions, so there is no deferred work to perform.
        completion(nil)
    }

    /// Centred text inset from the screen edges by the sum of `insets`.
    private func centredText(title: String,
                             font: TextProperties.Font,
                             weight: TextProperties.Weight,
                             foregroundStyle: TextProperties.ForegroundStyle,
                             insets: [ContainerProperties.Spacing]) -> Component {
        let text: Component = .textComponent(properties: .init(
            title: title,
            font: font,
            weight: weight,
            alignment: .center,
            foregroundStyle: foregroundStyle)
        )

        return insets.reduce(text) { component, inset in
            .containerComponent(properties: .init(
                component: component,
                horizontalSpacing: inset,
                alignment: .center)
            )
        }
    }
}

private extension PlaygroundCalculatingInteractor {
    enum SelectionKey {
        // Written on the weekly split screen.
        static let weeklySplit = "playground-weekly-split"
    }

    enum Layout {
        static let spinnerSide: Double = 96
    }
}

private extension PlaygroundCalculatingInteractor {
    /// The weekly split options, matching the selection ids written on the weekly split screen.
    enum WeeklySplit: String {
        case carbCycling = "carb-cycling"
        case sameEveryDay = "same-every-day"

        var calculatingMessage: String {
            switch self {
            case .carbCycling:
                return "Maintenance calories, then the split across five low-carb days and two high-carb days."
            case .sameEveryDay:
                return "Maintenance calories, then one daily target for all seven days."
            }
        }
    }
}
