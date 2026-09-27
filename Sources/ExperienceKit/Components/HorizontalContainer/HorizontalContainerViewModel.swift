import Foundation

public final class HorizontalContainerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency

    public let id: UUID
    let children: [AnyComponentViewModel]
    let viewProvider: ViewProvider
    let spacing: CGFloat
    let alignment: HorizontalContainerProperties.Alignment
    let distribution: HorizontalContainerProperties.Distribution
    let contentInset: CGFloat
    let itemWidth: CGFloat?

    public init(properties: HorizontalContainerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        // Children share this session's dependency, so components such as
        // TextField keep writing to the injected selection state store.
        self.children = properties.components.map {
            dependency.viewModelProvider.viewModel(for: $0, dependency: dependency)
        }
        self.viewProvider = dependency.viewProvider
        self.spacing = properties.spacing.value
        self.alignment = properties.alignment
        self.distribution = properties.distribution
        self.contentInset = properties.contentInset.value
        self.itemWidth = properties.itemWidth.map { CGFloat($0) }
    }
}

private extension HorizontalContainerProperties.Spacing {
    var value: CGFloat {
        switch self {
        case .none: return .spacing.none
        case .small: return .spacing.small
        case .medium: return .spacing.medium
        case .large: return .spacing.large
        }
    }
}
