import Foundation
import SwiftUI

// sourcery: register
final class ValidationMessageComponentRegister: ComponentRegister {
    var contentType: String {
        "validationmessage"
    }

    var propertiesType: Properties.Type {
        ValidationMessageProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ValidationMessageViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ValidationMessageView(any: viewModel))
    }
}
