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
