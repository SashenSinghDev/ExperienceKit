//
//  SegmentedControlComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 25/09/2026.
//

import ExperienceKit
import SwiftUI

final class SegmentedControlComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Two segments")),
            insetSegmentedControl(
                options: [
                    .init(label: "One way", value: "one-way"),
                    .init(label: "Return", value: "return")
                ],
                selectedValue: "return",
                accessibilityLabel: "Trip type"
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Three segments")),
            insetSegmentedControl(
                options: [
                    .init(label: "Day", value: "day"),
                    .init(label: "Week", value: "week"),
                    .init(label: "Month", value: "month")
                ],
                selectedValue: "week",
                accessibilityLabel: "Date range"
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Four segments")),
            insetSegmentedControl(
                options: [
                    .init(label: "XS", value: "xs"),
                    .init(label: "S", value: "s"),
                    .init(label: "M", value: "m"),
                    .init(label: "L", value: "l")
                ],
                selectedValue: "m",
                accessibilityLabel: "Size"
            )
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func insetSegmentedControl(options: [SegmentedControlProperties.Option],
                                       selectedValue: String,
                                       accessibilityLabel: String) -> Component {
        .containerComponent(properties: .init(
            component: .segmentedcontrolComponent(properties: .init(
                options: options,
                selectedValue: selectedValue,
                accessibilityLabel: accessibilityLabel
            )),
            horizontalSpacing: .medium)
        )
    }
}
