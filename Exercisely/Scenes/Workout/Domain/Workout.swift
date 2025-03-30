//
//  Workout.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation
import SwiftData

@Model
class Workout {
    
    var focus: Focus?
    
    @Attribute(.unique)
    private var dateInt: SimpleDate.RawValue

    var date: SimpleDate {
        get { SimpleDate(rawValue: dateInt)! }
        set { dateInt = newValue.rawValue }
    }

    @Relationship(deleteRule: .cascade)
    var sections: [Section]
    
    
    init(date: SimpleDate = .today) {
        self.dateInt = date.rawValue
        self.sections = []
    }
    
    func append(section: Section) {
        let order = sortedSections.last?.order ?? 0
        section.order = order + 1
        sections.append(section)
    }
    
    func remove(section: Section) {
        sections.removeAll { $0.id == section.id }
    }
    
    var sortedSections: [Section] {
        sections.sorted(by: { $0.order < $1.order })
    }
    
    func getExercises(named name: Exercise.Name) -> [Exercise] {
        sortedSections.reduce(into: []) { exercises, section in
            exercises.append(contentsOf: section.getExercises(named: name))
        }
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
