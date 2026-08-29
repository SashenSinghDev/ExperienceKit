//
//  NavigationBarPresentation.swift
//  ExperienceKit
//
//  Created by Codex on 23/08/2026.
//

struct NavigationBarPresentation {
    enum DisplayMode {
        case automatic
        case inline
        case large
    }

    let title: String
    let displayMode: DisplayMode

    init(experienceViewModel: ExperienceViewModel?) {
        title = experienceViewModel?.navigationBar?.title ?? ""
        switch experienceViewModel?.navigationBar?.displayMode {
        case .automatic:
            displayMode = .automatic
        case .inline:
            displayMode = .inline
        case .large:
            displayMode = .large
        case nil:
            displayMode = .inline
        }
    }
}
