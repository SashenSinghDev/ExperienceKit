import Foundation

public struct AnyProperties: Properties {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> AnyProperties {
        fatalError("Not to be used")
    }
}

public struct AnyComponentViewModel: ComponentViewModel, Identifiable {
    public let id: UUID
    public typealias P = AnyProperties

    public let value: AnyObject

    /// The XPA content type of the component used to generate the `ComponentViewModel` contained
    /// in the `AnyComponentViewModel` value. It's used to dequeuing reusable cells.
    let contentType: String

    public init(properties: AnyProperties, id: UUID) {
        fatalError("Not to be used")
    }

    init<T: ComponentViewModel>(_ viewModel: T, contentType: String) {
        self.value = viewModel as AnyObject
        self.contentType = contentType
        self.id = viewModel.id
    }
}
