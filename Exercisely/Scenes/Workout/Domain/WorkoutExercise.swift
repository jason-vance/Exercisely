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


enum ExerciseGroup {
    case set([Workout.Exercise])
    //TODO: Add superset
    //TODO: Add dropset
}

extension ExerciseGroup {
    static let sampleSingle: ExerciseGroup = .set([.sampleArcherPress])
    static let sampleSimpleSet: ExerciseGroup = .set([.sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp])
    static let sampleVariableWeightAndRepSet: ExerciseGroup = .set([
        .init(name: .sampleMachineShoulderPress, weight: .pounds(50), reps: .init(12)!)!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(60), reps: .init(10)!)!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(70), reps: .init(8)!)!,
    ])
    static let sampleVariableDistanceAndDurationSet: ExerciseGroup = .set([
        .init(name: .sampleTreadmill, distance: .meters(100), duration: .seconds(15)!)!,
        .init(name: .sampleTreadmill, distance: .meters(110), duration: .seconds(20)!)!,
        .init(name: .sampleTreadmill, distance: .meters(125), duration: .seconds(25)!)!,
    ])
}

extension ExerciseGroup: Identifiable {
    var id: Workout.Exercise.ID {
        switch self {
        case .set(let exercises):
            return exercises.first!.id
        }
    }
    
    var name: String {
        switch self {
        case .set(let exercises):
            return exercises.first?.name.formatted() ?? "Unnamed Set"
        }
    }
    
    var exercises: [Workout.Exercise] {
        switch self {
        case .set(let exercises):
            return exercises
        }
    }
    
    func contains(_ exercise: Workout.Exercise) -> Bool {
        contains(exercise.id)
    }
    
    func contains(_ exerciseId: Workout.Exercise.ID) -> Bool {
        switch self {
        case .set(let e):
            return e.contains(where: { $0.id == exerciseId })
        }
    }
}


extension Workout.Exercise {
    fileprivate static func groupAsSet(
        _ exercises: [Workout.Exercise],
        _ i: Int, _ currentSetLength: Int,
        _ groupedExercises: inout [ExerciseGroup]
    ) {
        let setExercises = Array(exercises[i..<(i + currentSetLength)])
        groupedExercises += [.set(setExercises)]
    }
    
    static func group(exercises: [Workout.Exercise]) -> [ExerciseGroup] {
        if exercises.isEmpty { return [] }
        
        var groupedExercises: [ExerciseGroup] = []
        
        var currentExercise: Name = exercises.first!.name
        var i = 0
        var currentSetLength = 0
        
        while i + currentSetLength < exercises.count {
            if exercises[i + currentSetLength].name == currentExercise {
                currentSetLength += 1
            } else {
                groupAsSet(exercises, i, currentSetLength, &groupedExercises)

                currentExercise = exercises[i + currentSetLength].name
                i += currentSetLength
                currentSetLength = 0
            }
        }
        
        groupAsSet(exercises, i, currentSetLength, &groupedExercises)

        return groupedExercises
    }
}
