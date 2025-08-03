//
//  ExperienceInteractor.swift
//
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation

public protocol ExperienceInteractor {
    var navigationBarModel: NavigationBarModel? { get }
    func load(completion: @escaping (ExperienceType) -> Void)
    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void)
}

public protocol HasExperienceInteractor {
    var experienceInteractor: ExperienceInteractor { get }
}
