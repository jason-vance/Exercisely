//
//  WorkoutSection.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import Foundation

//TODO: Make ValueOf types
extension Workout {
    class Section {
        
        let id: UUID
        var name: String
        var activities: [Activity]
        
        init?(name: String) {
            id = UUID()
            self.name = name
            self.activities = []
        }
        
        func append(activity: Activity) {
            activities.append(activity)
        }
    }
}

extension Workout.Section: Identifiable { }

extension Workout.Section {
    static var sampleWarmup: Workout.Section {
        let section = Workout.Section(name: "Warmup")!
        
        section.append(activity: .sampleTreadmill)
        
        section.append(activity: .sampleYtw)
        section.append(activity: .sampleArcherPress)
        section.append(activity: .sampleTrxChestStretch)
        
        section.append(activity: .sampleYtw)
        section.append(activity: .sampleArcherPress)
        section.append(activity: .sampleTrxChestStretch)
        
        return section
    }
    
    static var sampleWorkout: Workout.Section {
        let section = Workout.Section(name: "Workout")!
        
        section.append(activity: .sampleTurkishGetUp)
        section.append(activity: .sampleShoulderTouches)
        section.append(activity: .sampleKettlebellShoulderPress)
        
        section.append(activity: .sampleTurkishGetUp)
        section.append(activity: .sampleShoulderTouches)
        section.append(activity: .sampleKettlebellShoulderPress)
        
        section.append(activity: .sampleTurkishGetUp)
        section.append(activity: .sampleShoulderTouches)
        section.append(activity: .sampleKettlebellShoulderPress)
        
        section.append(activity: .sampleMachineShoulderPress)
        
        section.append(activity: .sampleMachineUnderhandRow)
        
        return section
    }
    
    static var sampleCooldown: Workout.Section {
        let section = Workout.Section(name: "Cooldown")!
        
        section.append(activity: .sampleHike)
        
        return section
    }
}
