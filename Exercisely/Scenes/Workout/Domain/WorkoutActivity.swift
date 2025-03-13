//
//  WorkoutActivity.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation

//TODO: Make ValueOf types
extension Workout {
    class Activity {
        
        let id: UUID
        var exercise: Exercise
        var weight: Double?
        var reps: Int?
        var distance: Double?
        var time: TimeInterval?
        
        init?(
            exercise: Exercise,
            weight: Double? = nil,
            reps: Int? = nil,
            distance: Double? = nil,
            time: TimeInterval? = nil
        ) {
            if reps == nil && distance == nil && time == nil {
                return nil
            }
            
            self.id = UUID()
            self.exercise = exercise
            self.weight = weight
            self.reps = reps
            self.distance = distance
            self.time = time
        }
    }
}

extension Workout.Activity: Identifiable { }

extension Workout.Activity: Equatable {
    static func == (lhs: Workout.Activity, rhs: Workout.Activity) -> Bool {
        lhs.exercise == rhs.exercise
        && lhs.weight == rhs.weight
        && lhs.reps == rhs.reps
        && lhs.distance == rhs.distance
        && lhs.time == rhs.time
    }
}

extension Workout.Activity {
    static let sampleTreadmill: Workout.Activity = .init(exercise: .sampleTreadmill, time: 300)!
    static let sampleYtw: Workout.Activity = .init(exercise: .sampleYtw, reps: 5)!
    static let sampleArcherPress: Workout.Activity = .init(exercise: .sampleArcherPress, reps: 10)!
    static let sampleTrxChestStretch: Workout.Activity = .init(exercise: .sampleTrxChestStretch, reps: 5)!
    static let sampleTurkishGetUp: Workout.Activity = .init(exercise: .sampleTurkishGetUp, weight: 5, reps: 3)!
    static let sampleShoulderTouches: Workout.Activity = .init(exercise: .sampleShouldersTouches, reps: 10)!
    static let sampleKettlebellShoulderPress: Workout.Activity = .init(exercise: .sampleKettlebellShoulderPress, weight: 15, reps: 5)!
    static let sampleMachineShoulderPress: Workout.Activity = .init(exercise: .sampleMachineShoulderPress, weight: 95, reps: 15)!
    static let sampleMachineUnderhandRow: Workout.Activity = .init(exercise: .sampleMachineUnderhandRow, weight: 95, reps: 15)!
    static let sampleHike: Workout.Activity = .init(exercise: .sampleHike, distance: 1.5)!
}

