//
//  AnyExperienceViewModel.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public protocol ComponentViewModel {
    associatedtype P: Properties

    var id: UUID { get }

    init(properties: P, id: UUID)
}

extension ComponentViewModel {
    init(any: Any, id: UUID) {
        self.init(properties: any as! P,
                  id: id)
    }
}

public struct AnyProperties: Properties {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> AnyProperties {
        fatalError("Not to be used")
    }
}

public struct AnyComponentViewModel: ComponentViewModel, Identifiable  {
    public let id: UUID
    public typealias P = AnyProperties

    let value: AnyObject
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
