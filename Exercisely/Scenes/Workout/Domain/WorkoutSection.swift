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
        var exercises: [Exercise]
        
        
        init(name: String, order: Int) {
            self.name = name
            self.order = order
            self.exercises = []
        }
        
        func append(exercise: Exercise) {
            exercises.append(exercise)
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
        section.append(exercise: .sampleShoulderTouches)
        section.append(exercise: .sampleKettlebellShoulderPress)
        
        section.append(exercise: .sampleTurkishGetUp)
        section.append(exercise: .sampleShoulderTouches)
        section.append(exercise: .sampleKettlebellShoulderPress)
        
        section.append(exercise: .sampleTurkishGetUp)
        section.append(exercise: .sampleShoulderTouches)
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
