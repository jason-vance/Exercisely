//
//  WorkoutExercise.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation
import SwiftData

extension Workout {
    @Model
    class Exercise {
        
        var name: Name
        var weight: Weight?
        var reps: Reps?
        var distance: Distance?
        var duration: Duration?
        var rest: Duration?
        var order: Int
        
        @Relationship(inverse: \Workout.Section.exercises)
        var workoutSection: Workout.Section?
        
        var date: SimpleDate? { workoutSection?.workout?.date }
        
        init?(
            name: Name,
            weight: Weight? = nil,
            reps: Reps? = nil,
            distance: Distance? = nil,
            duration: Duration? = nil,
            rest: Duration? = nil,
            order: Int = 0
        ) {
            if reps == nil && distance == nil && duration == nil {
                return nil
            }
            
            self.name = name
            self.weight = weight
            self.reps = reps
            self.distance = distance
            self.duration = duration
            self.rest = rest
            self.order = order
        }
    }
}

extension Workout.Exercise: Identifiable { }

extension Workout.Exercise: Equatable {
    static func == (lhs: Workout.Exercise, rhs: Workout.Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

extension Workout.Exercise {
    static let sampleTreadmill: Workout.Exercise = .init(name: .sampleTreadmill, distance: .kilometers(1), duration: .minutes(5))!
    static let sampleYtw: Workout.Exercise = .init(name: .sampleYtw, reps: .init(5)!)!
    static let sampleArcherPress: Workout.Exercise = .init(name: .sampleArcherPress, reps: .init(10)!)!
    static let sampleTrxChestStretch: Workout.Exercise = .init(name: .sampleTrxChestStretch, reps: .init(5)!)!
    static let sampleTurkishGetUp: Workout.Exercise = .init(name: .sampleTurkishGetUp, weight: .kilograms(5), reps: .init(3)!)!
    static let sampleShoulderTouches: Workout.Exercise = .init(name: .sampleShouldersTouches, reps: .init(10)!)!
    static let sampleKettlebellShoulderPress: Workout.Exercise = .init(name: .sampleKettlebellShoulderPress, weight: .kilograms(5), reps: .init(5)!)!
    static let sampleMachineShoulderPress: Workout.Exercise = .init(name: .sampleMachineShoulderPress, weight: .pounds(95), reps: .init(15)!)!
    static let sampleMachineUnderhandRow: Workout.Exercise = .init(name: .sampleMachineUnderhandRow, weight: .pounds(95), reps: .init(15)!)!
    static let sampleHike: Workout.Exercise = .init(name: .sampleHike, distance: .miles(1.5), duration: .hours(0.25))!
}
