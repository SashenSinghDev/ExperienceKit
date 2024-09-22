//
//  ExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public protocol ExperiencePresenter {
    func performAction(_ action: Experience.Action)
    func navigate(_ id: UUID) -> AnyView
}
