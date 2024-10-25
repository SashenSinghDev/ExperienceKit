//
//  ExperienceInteractor.swift
//
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation

public protocol ExperienceInteractor {
    func load(completion: @escaping ([Component]) -> Void)
}

public protocol HasExperienceInteractor {
    var experienceInteractor: ExperienceInteractor { get }
}
