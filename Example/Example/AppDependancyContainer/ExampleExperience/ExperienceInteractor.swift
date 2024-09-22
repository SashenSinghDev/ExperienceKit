//
//  ExperienceInteractor.swift
//  Example
//
//  Created by Sashen Singh on 05/09/2024.
//

import Foundation
import ExperienceKit
import SwiftUI

final class ExampleExperienceInteractor: ExperienceInteractor {

    let experienceService: ExperienceService
    var components = [Component]()

    init(experienceService: ExperienceService) {
        self.experienceService = experienceService
    }

    func load(completion: @escaping ([Component]) -> Void) {
        let componentsToReturn = [Component(contentType: "exampleComponent",
                                            properties: ExampleProperties(title: "mockTitle",
                                                                          navigationType: .deepdive),
                                            id: UUID()),
                                  Component(contentType: "exampleComponent",
                                            properties: ExampleProperties(title: "mockTitle2",
                                                                          navigationType: .deepdive),
                                            id: UUID())]

        components = componentsToReturn
        completion(componentsToReturn)
    }

    func navigate(for id: UUID) -> AnyView {
        guard let component = components.first(where: { $0.id == id }),
              let exampleProperties = component.properties as? ExampleProperties else { fatalError("component should be there but missing") }

        return AnyView(Text(exampleProperties.title))
    }

    func navigate(for viewModel: AnyComponentViewModel) -> AnyView {
        if let vm = viewModel.value as? ExampleViewModel {
            return AnyView(Text(vm.title))
        }
        return AnyView(EmptyView())
    }

    func navigate(for properties: AnyProperties) -> AnyView {
        if let prop = properties as? ExampleProperties {
            
        }

        return AnyView(EmptyView())
    }
}
