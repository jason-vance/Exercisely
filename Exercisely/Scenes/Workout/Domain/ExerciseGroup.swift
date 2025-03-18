//
//  ExerciseGroup.swift
//  Exercisely
//
//  Created by Jason Vance on 3/17/25.
//

import Foundation

enum ExerciseGroup {
    case set([Workout.Exercise])
    case dropSet([Workout.Exercise])
    //TODO: Add superset
}

extension ExerciseGroup: Identifiable {
    var id: Workout.Exercise.ID {
        switch self {
        case .set(let exercises):
            return exercises.first!.id
        case .dropSet(let exercises):
            return exercises.first!.id
        }
    }
    
    var name: String {
        switch self {
        case .set(let exercises):
            return exercises.first?.name.formatted() ?? "Unnamed Set"
        case .dropSet(let exercises):
            return exercises.first?.name.formatted() ?? "Unnamed Set"
        }
    }
    
    var exercises: [Workout.Exercise] {
        switch self {
        case .set(let exercises):
            return exercises
        case .dropSet(let exercises):
            return exercises
        }
    }
    
    func contains(_ exercise: Workout.Exercise) -> Bool {
        contains(exercise.id)
    }
    
    func contains(_ exerciseId: Workout.Exercise.ID) -> Bool {
        switch self {
        case .set(let exercises):
            return exercises.contains(where: { $0.id == exerciseId })
        case .dropSet(let exercises):
            return exercises.contains(where: { $0.id == exerciseId })
        }
    }
}

extension ExerciseGroup {
    
    @discardableResult
    fileprivate static func groupAsSet(
        _ exercises: [Workout.Exercise],
        _ i: inout Int,
        _ groupedExercises: inout [ExerciseGroup]
    ) -> Bool {
        guard i < exercises.count else { return false }
        
        let prevExerciseName: Workout.Exercise.Name = exercises[i].name
        var currentSetLength = 1
        
        let insertSetIntoGroupedExercises: (inout Int, inout [ExerciseGroup]) -> Bool = { i, groupedExercises in
            let setExercises = Array(exercises[i..<(i + currentSetLength)])
            groupedExercises += [.set(setExercises)]
            i += currentSetLength
            return true
        }
        
        while i + currentSetLength < exercises.count {
            let exercise = exercises[i + currentSetLength]
            
            if exercise.name == prevExerciseName {
                currentSetLength += 1
                continue
            } else {
                return insertSetIntoGroupedExercises(&i, &groupedExercises)
            }
        }
        
        return insertSetIntoGroupedExercises(&i, &groupedExercises)
    }
    
    fileprivate static func groupAsDropSet(
        _ exercises: [Workout.Exercise],
        _ i: inout Int,
        _ groupedExercises: inout [ExerciseGroup]
    ) -> Bool {
        guard i < exercises.count else { return false }
        
        var prevExercise: Workout.Exercise = exercises[i]
        var currentSetLength = 1
        
        let isContinuationOfDropSet: (Workout.Exercise) -> Bool = { exercise in
            let isStepDown: Bool = {
                if let prevWeight = prevExercise.weight, let currentWeight = exercise.weight {
                    return prevWeight > currentWeight
                }
                if let prevDuration = prevExercise.duration, let currentDuration = exercise.duration {
                    return prevDuration > currentDuration
                }
                return false
            }()
            
            return exercise.name == prevExercise.name &&
            prevExercise.rest == nil &&
            isStepDown
        }
        
        let insertDropSetIntoGroupedExercises: (inout Int, inout [ExerciseGroup]) -> Bool = { i, groupedExercises in
            if currentSetLength > 1 {
                let setExercises = Array(exercises[i..<(i + currentSetLength)])
                groupedExercises += [.dropSet(setExercises)]
                i += currentSetLength
                return true
            }
            return false
        }
        
        while i + currentSetLength < exercises.count {
            let exercise = exercises[i + currentSetLength]
            
            if isContinuationOfDropSet(exercise) {
                currentSetLength += 1
                prevExercise = exercise
                continue
            } else {
                return insertDropSetIntoGroupedExercises(&i, &groupedExercises)
            }
        }
        
        return insertDropSetIntoGroupedExercises(&i, &groupedExercises)
    }
    
    static func group(exercises: [Workout.Exercise]) -> [ExerciseGroup] {
        if exercises.isEmpty { return [] }
        
        var groupedExercises: [ExerciseGroup] = []
        
        var i = 0
        
        while i < exercises.count {
            if groupAsDropSet(exercises, &i, &groupedExercises) { continue }
            groupAsSet(exercises, &i, &groupedExercises)
        }

        return groupedExercises
    }
}

extension ExerciseGroup {
    static let sampleSingle: ExerciseGroup = .set([.sampleArcherPress])
    static let sampleSimpleSet: ExerciseGroup = .set([.sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp])
    static let sampleVariableWeightAndRepSet: ExerciseGroup = .set([
        .init(name: .sampleMachineShoulderPress, weight: .pounds(50), reps: .init(12))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(60), reps: .init(10))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(70), reps: .init(8))!,
    ])
    static let sampleVariableDistanceAndDurationSet: ExerciseGroup = .set([
        .init(name: .sampleTreadmill, distance: .meters(100), duration: .seconds(15))!,
        .init(name: .sampleTreadmill, distance: .meters(110), duration: .seconds(20))!,
        .init(name: .sampleTreadmill, distance: .meters(125), duration: .seconds(25))!,
    ])
    
    static let sampleDropSet: ExerciseGroup = .dropSet([
        .init(name: .sampleMachineShoulderPress, weight: .pounds(50), reps: .init(10))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(40), reps: .init(11))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(30), reps: .init(9))!,
    ])
    
    static let sampleFakeDropSetButItHasRests: ExerciseGroup = .dropSet([
        .init(name: .sampleMachineShoulderPress, weight: .pounds(50), reps: .init(10), rest: .init(value: 90, unit: .seconds))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(40), reps: .init(11), rest: .init(value: 90, unit: .seconds))!,
        .init(name: .sampleMachineShoulderPress, weight: .pounds(30), reps: .init(9))!,
    ])
}
