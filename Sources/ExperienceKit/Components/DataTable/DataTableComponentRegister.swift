import Foundation
import SwiftUI

// sourcery: register
final class DataTableComponentRegister: ComponentRegister {
    var contentType: String {
        "datatable"
    }

    var propertiesType: Properties.Type {
        DataTableProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(DataTableViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(DataTableView(any: viewModel))
    }
}
