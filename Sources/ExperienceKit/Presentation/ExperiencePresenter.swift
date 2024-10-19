//
//  ExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public protocol ExperiencePresenter: ObservableObject {
    var state: PresenterState { get }
    func load()
}

public enum PresenterState {
     case idle
     case loading
     case failed(Error)
     case loaded([AnyComponentViewModel])
 }
