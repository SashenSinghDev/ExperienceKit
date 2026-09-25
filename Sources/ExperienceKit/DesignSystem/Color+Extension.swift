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

    enum surface {
        static let primary = Color("surface/primary", bundle: .module)
    }

    enum text {
        static let primary = Color("text/primary", bundle: .module)
    }

    enum labels {
        static let primary = Color("labels/primary", bundle: .module)
    }

    enum separators {
        static let nonOpaque = Color("separators/non-opaque", bundle: .module)
    }
}

extension ShapeStyle where Self == Color {
    static var button: Color.button.Type { Color.button.self }
    static var progressStepper: Color.progressStepper.Type { Color.progressStepper.self }
    static var surface: Color.surface.Type { Color.surface.self }
    static var text: Color.text.Type { Color.text.self }
    static var labels: Color.labels.Type { Color.labels.self }
    static var separators: Color.separators.Type { Color.separators.self }
}
