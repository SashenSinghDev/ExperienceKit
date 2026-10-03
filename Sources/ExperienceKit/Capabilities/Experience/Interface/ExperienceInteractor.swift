//
//  ExperienceInteractor.swift
//
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation

public protocol ExperienceInteractor {
    var experienceViewModel: ExperienceViewModel? { get }
    func load(completion: @escaping (ExperienceType) -> Void)
    /// Performs the work a component asked for.
    ///
    /// - Parameters:
    ///   - workId: Identifies the work, as set on the component that requested it.
    ///   - values: The values the component reports with the work, for example the
    ///     text of a text field or the selected ids of a selection group. Empty when
    ///     the work carries no values, such as a button's navigation work.
    ///   - completion: Call exactly once. Pass an `ExperienceType` to render it in
    ///     place of the current screen, or `nil` to leave the screen as it is.
    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void)
}

public protocol HasExperienceInteractor {
    var experienceInteractor: ExperienceInteractor { get }
}
