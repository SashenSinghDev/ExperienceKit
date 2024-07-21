//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation

final class ExampleViewModel: ComponentViewModel {
    let id: UUID
    let title: String

    init(properties: ExampleProperties, id: UUID) {
        self.id = id
        self.title = properties.title
    }
}
