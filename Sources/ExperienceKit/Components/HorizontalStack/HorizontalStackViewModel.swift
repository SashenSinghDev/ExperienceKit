import Foundation

public final class HorizontalStackViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let title: String

    public init(properties: HorizontalStackProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
    }
}
