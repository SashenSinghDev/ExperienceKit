//
//  WelcomeViewModel.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

public final class WelcomeViewModel: ComponentViewModel, ObservableObject {
    public let id: UUID
    let image: ExperienceImage

    public init(properties: WelcomeProperties,
         id: UUID) {
        self.id = id
        self.image = properties.image
    }
}
