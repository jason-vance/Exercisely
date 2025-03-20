//
//  WorkoutSection.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation
import SwiftData

extension Workout {
    @Model
    class Section {
        
        var name: String
        var order: Int
        
        @Relationship(deleteRule: .cascade)
        private var exercises: [Exercise]
        
        
        init(name: String, order: Int = 0) {
            self.name = name
            self.order = order
            self.exercises = []
        }
        
        func append(exercise: Exercise) {
            let order = sortedExercises.last?.order ?? 0
            exercise.order = order + 1
            exercises.append(exercise)
        }
        
        func insert(exercise: Exercise, after existingExercise: Exercise) {
            let sortedExercises = self.sortedExercises
            guard let index = sortedExercises.firstIndex(where: { $0.id == existingExercise.id }) else {
                print("Could not find existing exercise to insert after")
                return
            }
            
            //Shift other exercises' order back one
            for i in index + 1..<sortedExercises.count {
                sortedExercises[i].order += 1
            }
            
            exercise.order = existingExercise.order + 1
            exercises.append(exercise)
        }
        
        func remove(exercise: Exercise) {
            removeAll(exercises: [exercise])
        }
        
        func removeAll(exercises: [Exercise]) {
            self.exercises.removeAll { exercises.map(\.id).contains($0.id) }
        }
        
        var sortedExercises: [Exercise] {
            exercises.sorted(by: { $0.order < $1.order })
        }
        
        var groupedExercises: [ExerciseGroup] {
            ExerciseGroup.group(exercises: sortedExercises)
        }
    }
}

extension Workout.Section: Identifiable { }

extension Workout.Section {
    static var sampleWarmup: Workout.Section {
        let section = Workout.Section(name: "Warm-Up", order: 0)
        
        section.append(exercise: .sampleTreadmill)
        
        section.append(exercise: .sampleYtw)
        section.append(exercise: .sampleArcherPress)
        section.append(exercise: .sampleTrxChestStretch)
        
        section.append(exercise: .sampleYtw)
        section.append(exercise: .sampleArcherPress)
        section.append(exercise: .sampleTrxChestStretch)
        
        return section
    }
    
    static var sampleWorkout: Workout.Section {
        let section = Workout.Section(name: "Workout", order: 1)
        
        section.append(exercise: .sampleTurkishGetUp)
        section.append(exercise: .sampleTurkishGetUp)
        section.append(exercise: .sampleTurkishGetUp)
        
        section.append(exercise: .sampleShoulderTouches)
        section.append(exercise: .sampleShoulderTouches)
        section.append(exercise: .sampleShoulderTouches)

        section.append(exercise: .sampleKettlebellShoulderPress)
        section.append(exercise: .sampleKettlebellShoulderPress)
        section.append(exercise: .sampleKettlebellShoulderPress)
        
        section.append(exercise: .sampleMachineShoulderPress)
        section.append(exercise: .sampleMachineShoulderPress)

        section.append(exercise: .sampleMachineUnderhandRow)
        
        return section
    }
    
    static var sampleCooldown: Workout.Section {
        let section = Workout.Section(name: "Cooldown", order: 2)
        
        section.append(exercise: .sampleHike)
        
        return section
    }
}
