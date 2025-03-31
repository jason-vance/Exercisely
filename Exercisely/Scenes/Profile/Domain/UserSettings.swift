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
}
