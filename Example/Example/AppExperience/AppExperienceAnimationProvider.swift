//
//  AppExperienceAnimationProvider.swift
//  Example
//

import ExperienceKit
import SwiftUI

/// Supplies the views that ExperienceKit's `animation` component renders.
///
/// ExperienceKit only knows an animation by its `uri`. This is where the app
/// decides what each one is: a native SwiftUI animation today, and the place a
/// Lottie-backed view would be returned if the app adopts Lottie.
final class AppExperienceAnimationProvider: ExperienceAnimationProvider {
    enum AnimationURI {
        static let spinner = "spinner"
    }

    func animationView(for animation: ExperienceAnimation) -> AnyView? {
        switch animation.uri {
        case AnimationURI.spinner:
            return AnyView(SpinnerAnimationView(loop: animation.loop))
        default:
            return nil
        }
    }
}
