//
//  ExperienceAnimationProvider.swift
//  ExperienceKit
//

import SwiftUI

/// The animation an `animation` component asks the host app to render.
public struct ExperienceAnimation: Equatable {
    /// Lookup key for the animation, resolved by the app's provider.
    public let uri: String
    /// Identifier of the bundle the provider should load the animation from.
    public let bundle: String
    /// `true` repeats the animation continuously, `false` plays it once.
    public let loop: Bool

    public init(uri: String, bundle: String, loop: Bool) {
        self.uri = uri
        self.bundle = bundle
        self.loop = loop
    }
}

/// Supplies the view that renders an animation.
///
/// ExperienceKit has no animation engine. The host app implements this protocol
/// and returns any SwiftUI view for a given animation: a Lottie view, a native
/// SwiftUI animation, or anything else. The `animation` component owns the frame
/// and clipping; the returned view should fill the space it is given.
public protocol ExperienceAnimationProvider {
    /// Returns the view for `animation`, or `nil` when the provider does not
    /// recognise it. A `nil` result renders as an empty frame.
    func animationView(for animation: ExperienceAnimation) -> AnyView?
}

public protocol HasExperienceAnimationProvider {
    var experienceAnimationProvider: ExperienceAnimationProvider? { get }
}
