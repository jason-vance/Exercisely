//
//  WorkoutSection.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation

extension Workout {
    class Section {
        
        let id: UUID
        var name: String
        var exercises: [Exercise]
        
        init?(name: String) {
            id = UUID()
            self.name = name
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
        let section = Workout.Section(name: "Warm-Up")!
        
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
        let section = Workout.Section(name: "Workout")!
        
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
        let section = Workout.Section(name: "Cooldown")!
        
        section.append(exercise: .sampleHike)
        
        return section
    }
}
