//
//  SectionNameEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 6/22/26.
//

import SwiftUI
import SwiftData

struct SectionNameEditView: View {

    @Environment(\.dismiss) var dismiss

    @Query private var sections: [Workout.Section]

    @Binding var name: String

    @State private var nameString: String = ""
    @FocusState private var focus: Bool

    private static let defaultSuggestions: [String] = [
        "Warm-Up",
        "Workout",
        "Cooldown",
        "Stretching",
        "Cardio",
        "Core",
        "Mobility",
        "Accessories",
    ]

    init(name: Binding<String>) {
        self._name = name
    }

    private var isNameInvalid: Bool {
        nameString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var suggestions: [String] {
        var uniqueNames = Set(sections.map { $0.name })
        for name in Self.defaultSuggestions {
            uniqueNames.insert(name)
        }

        return uniqueNames
            .filter { nameString.isEmpty || $0.lowercased().contains(nameString.lowercased()) }
            .sorted()
    }

    private func saveSectionName() {
        let trimmed = nameString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        self.name = trimmed
        dismiss()
    }

    var body: some View {
        NavigationStack {
            List {
                NameField()
                if !suggestions.isEmpty {
                    Suggestions()
                }
            }
            .listDefaultModifiers()
            .toolbar { Toolbar() }
            .toolbarTitleDisplayMode(.inline)
            .animation(.snappy, value: nameString)
        }
    }

    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Section Name")
                .navigationBarTitle()
        }
        ToolbarItem(placement: .topBarLeading) {
            CancelButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
            SaveButton()
        }
    }

    @ViewBuilder private func CancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.accentColor)
        }
    }

    @ViewBuilder private func SaveButton() -> some View {
        Button {
            saveSectionName()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
        .disabled(isNameInvalid)
    }

    @ViewBuilder private func NameField() -> some View {
        Section {
            VStack {
                TextField(
                    text: $nameString,
                    label: { Text("Warm-Up, Workout, etc...") }
                )
                .submitLabel(.done)
                .autocapitalization(.words)
                .onSubmit { saveSectionName() }
                .focused($focus)
                .fieldButton()
            }
            .workoutExerciseRow()
            .onAppear {
                focus = true
            }
        } header: {
            SectionHeader("Name")
        }
    }

    @ViewBuilder private func Suggestions() -> some View {
        Section {
            ForEach(suggestions, id: \.self) { suggestion in
                Suggestion(suggestion)
            }
        } header: {
            SectionHeader("Suggestions")
        }
    }

    @ViewBuilder private func Suggestion(_ suggestion: String) -> some View {
        Button {
            nameString = suggestion
            saveSectionName()
        } label: {
            Text(suggestion)
                .buttonDefaultModifiers()
        }
        .workoutExerciseRow()
    }
}

#Preview {
    SectionNameEditView(
        name: .constant("")
    )
    .modelContainer(for: Workout.self, inMemory: true)
    .foregroundStyle(Color.text)
    .background(Color.background)
}
