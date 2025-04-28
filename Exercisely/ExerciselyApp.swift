//
//  ExerciselyApp.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI
import SwiftData

//TODO: RELEASE: Add exercises not in library
@main
struct ExerciselyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            WorkoutViewNewExerciseSection.PendingSuperset.self
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
            TabView {
                Tab("Workout", systemImage: "figure.strengthtraining.traditional") {
                    NavigationStack {
                        WorkoutView()
                    }
                }
                Tab("Progress", systemImage: "chart.bar.fill") {
                    NavigationStack {
                        ExerciseProgressView()
                    }
                }
                Tab("Library", systemImage: "book.closed") {
                    NavigationStack {
                        ExerciseLibraryView()
                    }
                }
                Tab("Profile", systemImage: "person.crop.circle") {
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .foregroundStyle(Color.text)
            .background(Color.background)
        }
        .modelContainer(sharedModelContainer)
    }
}
