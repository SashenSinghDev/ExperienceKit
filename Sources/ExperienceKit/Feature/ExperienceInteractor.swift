//
//  File.swift
//  
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation
import SwiftUI

public protocol ExperienceInteractor {
    func load(completion: @escaping ([Component]) -> Void)
}

extension ExperienceInteractor {
    func navigate(for id: UUID) -> AnyView {
        AnyView(EmptyView())
    }
}

public protocol HasExperienceInteractor {
    var experienceInteractor: ExperienceInteractor { get }
}
