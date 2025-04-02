//
//  ExerciseEntry.swift
//  Exercisely
//
//  Created by Jason Vance on 4/1/25.
//

import Foundation

struct ExerciseLibrary: Codable, Equatable {
    let exercises: [ExerciseEntry]
    
    static func fromBundle() throws -> ExerciseLibrary {
        return Bundle.main.decode(ExerciseLibrary.self, from: "ExerciseLibrary.json")
    }
}

struct ExerciseEntry: Codable, Equatable {
    let name: String
    let alternateNames: [String]
    let musclesWorkedPrimary: [String]
    let musclesWorkedSecondary: [String]
    let bodyAreasTargeted: [String]
    let performanceSteps: [String]
    let equipment: [String]
    let exerciseType: [String]
    let difficulty: String
    let commonMistakes: [String]
    let trainerTips: [String]
    let variations: [String]
    let safetyWarnings: [String]
    let recommendedMinReps: Int
    let recommendedMaxReps: Int
    let recommendedMinSets: Int
    let recommendedMaxSets: Int
    let associatedExercises: [String]
    let searchTags: [String]
}
