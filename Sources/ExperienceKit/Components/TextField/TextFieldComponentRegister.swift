import Foundation
import SwiftUI

// sourcery: register
final class TextFieldComponentRegister: ComponentRegister {
    var contentType: String {
        "textfield"
    }

    var propertiesType: Properties.Type {
        TextFieldProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(TextFieldViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(TextFieldView(any: viewModel))
    }
}
