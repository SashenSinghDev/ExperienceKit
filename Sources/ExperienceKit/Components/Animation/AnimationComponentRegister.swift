import Foundation
import SwiftUI

// sourcery: register
final class AnimationComponentRegister: ComponentRegister {
    var contentType: String {
        "animation"
    }

    var propertiesType: Properties.Type {
        AnimationProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(AnimationViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(AnimationView(any: viewModel))
    }
}
