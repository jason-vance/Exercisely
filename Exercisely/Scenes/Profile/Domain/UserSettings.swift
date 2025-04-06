//
//  UserSettings.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage("UserSex") var userSex: UserSex = .unknown
    @AppStorage("BirthdateRawValue") var birthdateRawValue: Int = -1
    
    @AppStorage("WeightStepperValue") var weightStepperValue: Double = 5.0
    @AppStorage("RepsStepperValue") var repsStepperValue: Int = 1
    @AppStorage("DistanceStepperValue") var distanceStepperValue: Double = 1
    @AppStorage("DurationStepperValue") var durationStepperValue: Double = 5
    @AppStorage("RestStepperValue") var restStepperValue: Double = 5
    
    @AppStorage("DefaultWeightUnit") var defaultWeightUnitData: Data?
    var defaultWeightUnit: Weight.Unit {
        get {
            if let data = defaultWeightUnitData {
                return try! JSONDecoder().decode(Weight.Unit.self, from: data)
            } else {
                return .pounds
            }
        }
        set {
            defaultWeightUnitData = try? JSONEncoder().encode(newValue)
        }
    }
    
    @AppStorage("DefaultDistanceUnit") var defaultDistanceUnitData: Data?
    var defaultDistanceUnit: Distance.Unit {
        get {
            if let data = defaultDistanceUnitData {
                return try! JSONDecoder().decode(Distance.Unit.self, from: data)
            } else {
                return .miles
            }
        }
        set {
            defaultDistanceUnitData = try? JSONEncoder().encode(newValue)
        }
    }
    
    @AppStorage("DefaultDurationUnit") var defaultDurationUnitData: Data?
    var defaultDurationUnit: Workout.Exercise.Duration.Unit {
        get {
            if let data = defaultDurationUnitData {
                return try! JSONDecoder().decode(Workout.Exercise.Duration.Unit.self, from: data)
            } else {
                return .seconds
            }
        }
        set {
            defaultDurationUnitData = try? JSONEncoder().encode(newValue)
        }
    }
    
    @AppStorage("DefaultRestUnit") var defaultRestUnitData: Data?
    var defaultRestUnit: Workout.Exercise.Duration.Unit {
        get {
            if let data = defaultRestUnitData {
                return try! JSONDecoder().decode(Workout.Exercise.Duration.Unit.self, from: data)
            } else {
                return .seconds
            }
        }
        set {
            defaultRestUnitData = try? JSONEncoder().encode(newValue)
        }
    }
}
