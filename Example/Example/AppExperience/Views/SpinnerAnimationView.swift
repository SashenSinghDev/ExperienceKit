//
//  SpinnerAnimationView.swift
//  Example
//

import SwiftUI

/// A native SwiftUI spinner: a track ring with an arc that rotates around it.
///
/// Fills the frame ExperienceKit gives it. Stays still when Reduce Motion is on.
struct SpinnerAnimationView: View {
    let loop: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isRotating = false

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let lineWidth = side * Metrics.lineWidthRatio

            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: Metrics.arcFraction)
                    .stroke(Color.primary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(Metrics.arcStartAngle)
                    .rotationEffect(.degrees(isRotating ? 360 : 0))
            }
            .padding(lineWidth / 2)
            .frame(width: side, height: side)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .accessibilityLabel("Loading")
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(rotation) {
                isRotating = true
            }
        }
    }

    private var rotation: Animation {
        let turn = Animation.linear(duration: Metrics.turnDuration)
        return loop ? turn.repeatForever(autoreverses: false) : turn
    }
}

private enum Metrics {
    static let lineWidthRatio: CGFloat = 0.09
    static let arcFraction: CGFloat = 0.22
    static let turnDuration: TimeInterval = 1
    /// Centres the arc on the top of the ring before it starts rotating.
    static let arcStartAngle: Angle = .degrees(-90 - Double(arcFraction) * 180)
}

#Preview {
    SpinnerAnimationView(loop: true)
        .frame(width: 88, height: 88)
}
