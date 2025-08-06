//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

// sourcery: register
final class ExampleComponentRegister: ComponentRegister {
    var contentType: String {
        "exampleComponent"
    }

    var propertiesType: Properties.Type {
        ExampleProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ExampleViewModel(any: component.properties,
                                               dependency: dependency,
                                               id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ExampleComponentView(any: viewModel))
    }
}
