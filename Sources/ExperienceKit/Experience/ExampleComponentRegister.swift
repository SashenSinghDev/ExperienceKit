//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

struct ExampleComponentRegister: ComponentRegister {
    var contentType: String {
        "exampleComponent"
    }

    var propertiesType: Properties.Type {
        ExampleProperties.self
    }

    func viewModel(from component: Component) -> AnyComponentViewModel {
        AnyComponentViewModel(ExampleViewModel(any: component.properties,
                                               id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel, presenter: ExperiencePresenter) -> AnyView {
        return AnyView(AnyContentView(ExampleComponentView(any: viewModel, presenter: presenter)))
    }
}
