//
//  Color+Extension.swift
//  ExperienceKit
//
//  Created by Sashen Suneel Singh on 31/08/2026.
//

import SwiftUI

extension Color {
    enum button {
        enum primary {
            static let background = Color("Button/primaryBackground", bundle: .module)
            static let label = Color("Button/primaryLabel", bundle: .module)
        }

        enum secondary {
            static let background = Color("Button/secondaryBackground", bundle: .module)
            static let label = Color("Button/secondaryLabel", bundle: .module)
            static let border = Color("Button/secondaryBorder", bundle: .module)
        }
    }

    enum progressStepper {
        static let activeSegment = Color("ProgressStepper/activeSegment", bundle: .module)
        static let inactiveSegment = Color("ProgressStepper/inactiveSegment", bundle: .module)
    }
}

extension ShapeStyle where Self == Color {
    static var button: Color.button.Type { Color.button.self }
    static var progressStepper: Color.progressStepper.Type { Color.progressStepper.self }
}
