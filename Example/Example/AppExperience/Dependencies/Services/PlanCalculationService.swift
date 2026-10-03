//
//  PlanCalculationService.swift
//  Example
//
//  Created by Claude on 03/10/2026.
//

import Foundation

/// Works out the user's weekly plan.
///
/// Interactors depend on this protocol, not on a concrete type, so
/// `AppExperienceProvider` decides which implementation a screen gets.
protocol PlanCalculationService {
    /// Calculates the plan, then calls `completion` on the main thread.
    func calculatePlan(completion: @escaping () -> Void)
}

/// Stands in for the real async plan calculation by waiting a fixed duration.
final class AppPlanCalculationService: PlanCalculationService {
    private let calculationDuration: TimeInterval

    init(calculationDuration: TimeInterval = Timing.calculationDuration) {
        self.calculationDuration = calculationDuration
    }

    func calculatePlan(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + calculationDuration, execute: completion)
    }
}

extension AppPlanCalculationService {
    enum Timing {
        static let calculationDuration: TimeInterval = 3
    }
}
