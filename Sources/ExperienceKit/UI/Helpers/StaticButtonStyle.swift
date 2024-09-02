//
//  StaticButtonStyle.swift
//
//
//  Created by Sashen Singh on 02/09/2024.
//

import Foundation
import SwiftUI

internal struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
