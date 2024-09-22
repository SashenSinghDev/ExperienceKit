//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

public final class ExampleViewModel: ComponentViewModel {

    public let id: UUID
    public let title: String
    let properties: ExampleProperties

    public init(properties: ExampleProperties,
         id: UUID) {
        self.id = id
        self.title = properties.title
        self.properties = properties
    }

    var navigatedView: AnyView? {
        return AnyView(Text("navigated"))
    }
}
