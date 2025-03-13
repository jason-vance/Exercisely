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


enum WorkoutActivityGroup {
    case single(Workout.Activity)
    case set([Workout.Activity])
}

extension WorkoutActivityGroup: Identifiable {
    var id: UUID {
        switch self {
        case .single(let activity):
            return activity.id
        case .set(let activities):
            return activities.first!.id
        }
    }
}


extension Workout.Activity {
    fileprivate static func groupAsSingleOrSet(_ activities: [Workout.Activity], _ i: Int, _ currentSetLength: Int, _ groupedActivities: inout [WorkoutActivityGroup]) {
        let setActivities = Array(activities[i..<(i + currentSetLength)])
        
        if setActivities.count == 1 {
            groupedActivities += [.single(setActivities[0])]
        } else {
            groupedActivities += [.set(setActivities)]
        }
    }
    
    static func group(activities: [Workout.Activity]) -> [WorkoutActivityGroup] {
        if activities.isEmpty {
            return []
        }
        
        var groupedActivities: [WorkoutActivityGroup] = []
        
        var currentExercise: Exercise = activities.first!.exercise
        var i = 0
        var currentSetLength = 0
        
        while i + currentSetLength < activities.count {
            if activities[i + currentSetLength].exercise == currentExercise {
                currentSetLength += 1
            } else {
                groupAsSingleOrSet(activities, i, currentSetLength, &groupedActivities)

                currentExercise = activities[i + currentSetLength].exercise
                i += currentSetLength
                currentSetLength = 0
            }
        }
        
        groupAsSingleOrSet(activities, i, currentSetLength, &groupedActivities)

        return groupedActivities
    }
}
