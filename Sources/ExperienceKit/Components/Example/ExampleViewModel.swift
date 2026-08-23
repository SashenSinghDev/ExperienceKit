//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

public final class ExampleViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperiencePresenterNotifier & HasRouter

    public let id: UUID
    let title: String
    let primaryButton: ButtonViewModel

    @Published public var profileText: String = "Enter your bio"
    @Published public var publishedAmount: Int = 1

    public init(properties: ExampleProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.primaryButton = .init(properties: .init(title: "Go to details", style: .primary, isFullWidth: true, navigation: .init(navigationType: .push(AnyExperienceID(rawValue: "fullScreen")), deferredLoadingWorkId: nil, navigationBarModel: nil)),
                                   dependency: dependency,
                                   id: UUID())
    }

    var navigatedView: AnyView? {
        return AnyView(Text("navigated"))
    }
}

extension ExampleViewModel: Hashable {
    public static func == (lhs: ExampleViewModel, rhs: ExampleViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var identifier: String {
        return UUID().uuidString
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
