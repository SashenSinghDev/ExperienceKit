//
//  ComponentRegister.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public protocol ComponentRegister {
    var contentType: String { get }
    var propertiesType: Properties.Type { get }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel
    func view(from viewModel: any ComponentViewModel) -> AnyView
}
