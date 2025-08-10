import Foundation

public final class ContainerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency

    public let id: UUID
    private let component: Component
    let anyComponentViewModel: AnyComponentViewModel
    let viewProvider: ViewProvider

    public init(properties: ContainerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.component = properties.component
        self.anyComponentViewModel = dependency.viewModelProvider.viewModel(for: self.component,
                                                                            dependency: dependency)
        self.viewProvider = dependency.viewProvider
    }
}
