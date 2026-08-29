//
//  Font.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 01/01/2025.
//

import SwiftUI

public extension Font {

    static var h1: Font {
        Font.system(size: 48.0, weight: .bold)
    }

    static var h3: Font {
        Font.system(size: 32.0, weight: .bold)
    }

    static var bodyXLargeSemiBold: Font {
        Font.system(size: 18.0, weight: .semibold)
    }

    static var bodyXLargeRegular: Font {
        Font.system(size: 18.0, weight: .regular)
    }

    static var bodyLargeBold: Font {
        Font.system(size: 16.0, weight: .bold)
    }
}
