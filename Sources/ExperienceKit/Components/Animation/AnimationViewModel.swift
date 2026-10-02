import Foundation
import SwiftUI

public final class AnimationViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperienceAnimationProvider

    public let id: UUID
    let animation: ExperienceAnimation
    let width: Double?
    let height: Double?
    private let experienceAnimationProvider: ExperienceAnimationProvider?

    public init(properties: AnimationProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.animation = ExperienceAnimation(uri: properties.uri,
                                             bundle: properties.bundle,
                                             loop: properties.loop)
        self.width = properties.width
        self.height = properties.height
        self.experienceAnimationProvider = dependency.experienceAnimationProvider
    }

    /// The view the host app injected for this animation, or `nil` when no
    /// provider is available or the provider does not recognise the animation.
    func animationView() -> AnyView? {
        experienceAnimationProvider?.animationView(for: animation)
    }
}
