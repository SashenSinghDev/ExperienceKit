import Foundation
import SwiftUI

// sourcery: register
final class ProgressStepperComponentRegister: ComponentRegister {
    var contentType: String {
        "progressstepper"
    }

    var propertiesType: Properties.Type {
        ProgressStepperProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ProgressStepperViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ProgressStepperView(any: viewModel))
    }
}
