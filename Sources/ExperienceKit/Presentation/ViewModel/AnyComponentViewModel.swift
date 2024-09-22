import Foundation

public protocol ComponentViewModel {
    associatedtype P: Properties

    var id: UUID { get }

    init(properties: P, id: UUID)
}

public extension ComponentViewModel {
    init(any: Any, id: UUID) {
        self.init(properties: any as! P, id: id)
    }
}

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
