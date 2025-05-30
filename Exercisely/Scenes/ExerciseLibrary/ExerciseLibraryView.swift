//
//  ExerciseLibraryView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/1/25.
//

import SwiftUI

//TODO: Add filtering (by muscles, body areas, equipment, exerciseType, difficulty, etc)
//TODO: Add more than just exercises to the library (routines, concepts, equipment, etc)
//TODO: Add ability to request an exercise be added (via email or something)
struct ExerciseLibraryView: View {
    
    @State private var exerciseLibrary: ExerciseLibrary? = nil
    
    @State private var searchText: String = ""
    @FocusState private var focus: Bool
    
    //TODO: Check more than just the name for searching
    //TODO: Sort by relevance when searching
    private var exercises: [ExerciseEntry] {
        guard let exercises = exerciseLibrary?.exercises else {
            return []
        }
        
        return exercises
            .sorted { $0.name < $1.name }
            .filter {
                guard !searchText.isEmpty else {
                    return true
                }
                return $0.name.lowercased().contains(searchText.lowercased())
            }
    }

    private func loadExerciseLibrary() {
        Task {
            guard let exerciseLibrary = try? ExerciseLibrary.fromBundle() else {
                print("Could not load exercise library")
                return
            }
            self.exerciseLibrary = exerciseLibrary
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar()
            List {
                ForEach(exercises, id: \.name) { exercise in
                    ExerciseEntryRow(exercise)
                }
            }
            .listDefaultModifiers()
            .scrollDismissesKeyboard(.immediately)
        }
        .onAppear { loadExerciseLibrary() }
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: exerciseLibrary)
        .animation(.snappy, value: searchText)
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Library")
                .navigationBarTitle()
        }
    }
    
    @ViewBuilder private func SearchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.accentColor)
            TextField(
                text: $searchText,
                label: {
                    Text("Name, muscle group, etc")
                }
            )
            .submitLabel(.search)
            .focused($focus)
            .fieldButton()
            .overlay(alignment: .trailing) {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .font(.footnote)
                        .bold()
                }
                .opacity(searchText.isEmpty ? 0 : 1)
                .offset(x: searchText.isEmpty ? 22 : 0)
            }
        }
        .padding()
        .background(Color.background)
    }
    
    //TODO: Show why the search result appears (ie. muscles: glutes)
    @ViewBuilder private func ExerciseEntryRow(_ entry: ExerciseEntry) -> some View {
        NavigationLinkNoChevron {
            ExerciseEntryDetailView(entry: entry)
        } label: {
            Text(entry.name)
        }
        .workoutExerciseRow()
    }
}

#Preview {
    NavigationStack {
        ExerciseLibraryView()
    }
}
