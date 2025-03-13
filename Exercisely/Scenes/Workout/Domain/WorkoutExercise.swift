//
//  WorkoutExercise.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation

//TODO: Make ValueOf types
extension Workout {
    class Exercise {
        
        let id: UUID
        var name: Name
        var weight: Weight?
        var reps: Int?
        var distance: Double?
        var time: TimeInterval?
        
        init?(
            name: Name,
            weight: Weight? = nil,
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

extension Workout.Exercise: Identifiable { }

extension Workout.Exercise: Equatable {
    static func == (lhs: Workout.Exercise, rhs: Workout.Exercise) -> Bool {
        lhs.name == rhs.name
        && lhs.weight == rhs.weight
        && lhs.reps == rhs.reps
        && lhs.distance == rhs.distance
        && lhs.time == rhs.time
    }
}

extension Workout.Exercise {
    static let sampleTreadmill: Workout.Exercise = .init(name: .sampleTreadmill, time: 300)!
    static let sampleYtw: Workout.Exercise = .init(name: .sampleYtw, reps: 5)!
    static let sampleArcherPress: Workout.Exercise = .init(name: .sampleArcherPress, reps: 10)!
    static let sampleTrxChestStretch: Workout.Exercise = .init(name: .sampleTrxChestStretch, reps: 5)!
    static let sampleTurkishGetUp: Workout.Exercise = .init(name: .sampleTurkishGetUp, weight: .kilograms(5), reps: 3)!
    static let sampleShoulderTouches: Workout.Exercise = .init(name: .sampleShouldersTouches, reps: 10)!
    static let sampleKettlebellShoulderPress: Workout.Exercise = .init(name: .sampleKettlebellShoulderPress, weight: .kilograms(5), reps: 5)!
    static let sampleMachineShoulderPress: Workout.Exercise = .init(name: .sampleMachineShoulderPress, weight: .pounds(95), reps: 15)!
    static let sampleMachineUnderhandRow: Workout.Exercise = .init(name: .sampleMachineUnderhandRow, weight: .pounds(95), reps: 15)!
    static let sampleHike: Workout.Exercise = .init(name: .sampleHike, distance: 1.5)!
}


enum ExerciseGroup {
    case single(Workout.Exercise)
    case set([Workout.Exercise])
}

extension ExerciseGroup: Identifiable {
    var id: UUID {
        switch self {
        case .single(let exercise):
            return exercise.id
        case .set(let exercises):
            return exercises.first!.id
        }
    }
}


extension Workout.Exercise {
    fileprivate static func groupAsSingleOrSet(_ exercises: [Workout.Exercise], _ i: Int, _ currentSetLength: Int, _ groupedExercises: inout [ExerciseGroup]) {
        let setExercises = Array(exercises[i..<(i + currentSetLength)])
        
        if setExercises.count == 1 {
            groupedExercises += [.single(setExercises[0])]
        } else {
            groupedExercises += [.set(setExercises)]
        }
    }
    
    static func group(exercises: [Workout.Exercise]) -> [ExerciseGroup] {
        if exercises.isEmpty {
            return []
        }
        
        var groupedExercises: [ExerciseGroup] = []
        
        var currentExercise: Name = exercises.first!.name
        var i = 0
        var currentSetLength = 0
        
        while i + currentSetLength < exercises.count {
            if exercises[i + currentSetLength].name == currentExercise {
                currentSetLength += 1
            } else {
                groupAsSingleOrSet(exercises, i, currentSetLength, &groupedExercises)

                currentExercise = exercises[i + currentSetLength].name
                i += currentSetLength
                currentSetLength = 0
            }
        }
        
        groupAsSingleOrSet(exercises, i, currentSetLength, &groupedExercises)

        return groupedExercises
    }
}
