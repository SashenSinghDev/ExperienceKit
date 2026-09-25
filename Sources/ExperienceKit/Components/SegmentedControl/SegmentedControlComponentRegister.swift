import Foundation
import SwiftUI

// sourcery: register
final class SegmentedControlComponentRegister: ComponentRegister {
    var contentType: String {
        "segmentedcontrol"
    }

    var propertiesType: Properties.Type {
        SegmentedControlProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(SegmentedControlViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(SegmentedControlView(any: viewModel))
    }
}
