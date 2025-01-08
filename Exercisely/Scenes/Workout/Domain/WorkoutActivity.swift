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
        var name: String
        var weight: Double?
        var reps: Int?
        var distance: Double?
        var time: TimeInterval?
        
        init?(
            name: String,
            weight: Double? = nil,
            reps: Int? = nil,
            distance: Double? = nil,
            time: TimeInterval? = nil
        ) {
            if reps == nil && distance == nil && time == nil {
                return nil
            }
            
            self.id = UUID()
            self.name = name
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
        lhs.name == rhs.name
        && lhs.weight == rhs.weight
        && lhs.reps == rhs.reps
        && lhs.distance == rhs.distance
        && lhs.time == rhs.time
    }
}

extension Workout.Activity {
    static let sampleTreadmill: Workout.Activity = .init(name: "Treadmill", time: 300)!
    static let sampleYtw: Workout.Activity = .init(name: "YTW", reps: 5)!
    static let sampleArcherPress: Workout.Activity = .init(name: "Archer Press", reps: 10)!
    static let sampleTrxChestStretch: Workout.Activity = .init(name: "TRX Chest Stretch", reps: 5)!
    static let sampleTurkishGetUp: Workout.Activity = .init(name: "Turkish Get-Up", weight: 5, reps: 3)!
    static let sampleShoulderTouches: Workout.Activity = .init(name: "Shoulders Touches", reps: 10)!
    static let sampleKettlebellShoulderPress: Workout.Activity = .init(name: "Kettlebell Shoulder Press", weight: 15, reps: 5)!
    static let sampleMachineShoulderPress: Workout.Activity = .init(name: "Machine Shoulder Press", weight: 95, reps: 15)!
    static let sampleMachineUnderhandRow: Workout.Activity = .init(name: "Machine Underhand Row", weight: 95, reps: 15)!
    static let sampleHike: Workout.Activity = .init(name: "Hike", distance: 1.5)!
}

