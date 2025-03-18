//
//  ExerciselyApp.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI
import SwiftData

//TODO: Try to get everything onto one screen if possible
@main
struct ExerciselyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorkoutView()
            }
            .foregroundStyle(Color.text)
            .background(Color.background)
        }
        .modelContainer(sharedModelContainer)
    }
}
