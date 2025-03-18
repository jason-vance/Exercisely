//
//  ExerciseGroup.swift
//  Exercisely
//
//  Created by Jason Vance on 3/17/25.
//

import Foundation

enum ExerciseGroup {
    case set([Workout.Exercise])
    //TODO: Add superset
    //TODO: Add dropset
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

extension ExerciseGroup {
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
        
        var currentExercise: Workout.Exercise.Name = exercises.first!.name
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
