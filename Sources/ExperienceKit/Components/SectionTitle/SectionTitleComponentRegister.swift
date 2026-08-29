//
//  SectionTitleComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation
import SwiftUI

// sourcery: register
final class SectionTitleComponentRegister: ComponentRegister {

    var contentType: String {
        "sectiontitle"
    }

    var propertiesType: Properties.Type {
        SectionTitleProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(SectionTitleViewModel(any: component.properties,
                                                    dependency: dependency,
                                                    id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(SectionTitleView(any: viewModel))
    }
}
