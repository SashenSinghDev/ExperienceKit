//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

public final class ExampleViewModel: ComponentViewModel, ObservableObject, Hashable {

    public static func == (lhs: ExampleViewModel, rhs: ExampleViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var identifier: String {
        return UUID().uuidString
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }

    public let id: UUID
    let title: String

    @Published public var profileText: String = "Enter your bio"
    @Published public var publishedAmount: Int = 1

    public init(properties: ExampleProperties,
         id: UUID) {
        self.id = id
        self.title = properties.title
    }

    var navigatedView: AnyView? {
        return AnyView(Text("navigated"))
    }
}
