import Foundation

public final class ContainerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency
    
    public enum Spacing {
        case small
        case medium
        case large

        var value: CGFloat {
            switch self {
            case .small: return .spacing.small
            case .medium: return .spacing.medium
            case .large: return .spacing.large
            }
        }
    }

    public enum Alignment {
        case leading
        case center
        case trailing
    }

    public let id: UUID
    private let component: Component
    let anyComponentViewModel: AnyComponentViewModel
    let viewProvider: ViewProvider
    let verticalSpacing: Spacing?
    let horizontalSpacing: Spacing?
    let alignment: Alignment?

    public init(properties: ContainerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.component = properties.component
        self.anyComponentViewModel = dependency.viewModelProvider.viewModel(for: self.component,
                                                                            dependency: dependency)
        self.viewProvider = dependency.viewProvider
        self.verticalSpacing = properties.verticalSpacing?.toSpacing
        self.horizontalSpacing = properties.horizontalSpacing?.toSpacing
        self.alignment = properties.alignment?.toAlignment
    }
}

private extension ContainerProperties.Spacing {
    var toSpacing: ContainerViewModel.Spacing {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}

private extension ContainerProperties.Alignment {
    var toAlignment: ContainerViewModel.Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}
