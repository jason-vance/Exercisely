//
//  Workout.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation

class Workout {
    
    let id: UUID
    var focus: Focus?
    var date: SimpleDate
    var sections: [Section]
    
    init() {
        self.id = UUID()
        self.date = .today
        self.sections = []
    }
    
    func append(section: Section) {
        sections.append(section)
    }
}

extension Workout {
    static var sample: Workout {
        let workout = Workout()
        workout.append(section: .sampleWarmup)
        workout.append(section: .sampleWorkout)
        workout.append(section: .sampleCooldown)
        return workout
    }
}
