import Foundation

public final class ContainerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let title: String

    public init(properties: ContainerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
    }
}
