//
//  ExerciseNameEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/14/25.
//

import SwiftUI
import SwiftData

//TODO: Put name field above list instead of inside it
//TODO: Autocapitalize words
//TODO: Dismiss keyboard on scroll
struct ExerciseNameEditView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @Query private var exercises: [Workout.Exercise]
    
    @Binding var name: Workout.Exercise.Name?

    @State private var nameString: String = ""
    @FocusState private var focus: Bool
    
    init(name: Binding<Workout.Exercise.Name?>) {
        self._name = name
    }
    
    private var isNameInvalid: Bool {
        Workout.Exercise.Name(nameString) == nil
    }
    
    private var suggestions: [Workout.Exercise.Name] {
        let names = exercises.map { $0.name }
        let uniqueNames = Set(names)
        return uniqueNames
            .filter { nameString.isEmpty || $0.formatted().lowercased().contains(nameString.lowercased()) }
            .sorted { $0.formatted() < $1.formatted() }
    }
    
    private func saveExerciseName() {
        guard let name = Workout.Exercise.Name(nameString) else {
            print("Name could not be created")
            return
        }
        
        self.name = name
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        List {
            NameField()
            if !suggestions.isEmpty {
                Suggestions()
            }
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: nameString)
        .onChange(of: name, initial: true) { _, newValue in
            nameString = newValue?.formatted() ?? ""
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Name")
                .bold(true)
                .foregroundStyle(Color.text)
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
            presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func SaveButton() -> some View {
        Button {
            saveExerciseName()
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
                        label: { Text(Workout.Exercise.Name.prompt.formatted()) }
                    )
                    .submitLabel(.done)
                    .onSubmit { saveExerciseName() }
                    .focused($focus)
                    .fieldButton()
                    
                    let isTooLong = nameString.count > Workout.Exercise.Name.maxTextLength
                    FieldCaption(
                        "\(isTooLong ? "Too long" : "") \(nameString.count)/\(Workout.Exercise.Name.maxTextLength)",
                        isError: isTooLong
                    )
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
            ForEach(suggestions) { suggestion in
                Suggestion(suggestion)
            }
        } header: {
            SectionHeader("Suggestions")
        }
    }
    
    @ViewBuilder private func Suggestion(_ suggestion: Workout.Exercise.Name) -> some View {
        Button {
            nameString = suggestion.formatted()
            saveExerciseName()
        } label: {
            Text(suggestion.formatted())
                .buttonDefaultModifiers()
        }
        .workoutExerciseRow()
    }
}

#Preview {
    var name: Workout.Exercise.Name? = nil
//    var name: Workout.Exercise.Name? = .init("Squats")

    NavigationStack {
        ExerciseNameEditView(
            name: .init(
                get: { name },
                set: { name = $0; print("Name: \(String(describing: $0?.formatted()))") }
            )
        )
    }
    .modelContainer(for: Workout.self, inMemory: true) { result in
        switch result {
        case .success(let modelContainer):
            let context = modelContainer.mainContext
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleYtw)
            context.insert(Workout.Exercise.sampleTreadmill)
            context.insert(Workout.Exercise.sampleArcherPress)
            context.insert(Workout.Exercise.sampleTrxChestStretch)
            context.insert(Workout.Exercise.sampleTurkishGetUp)
            context.insert(Workout.Exercise.sampleShoulderTouches)
            context.insert(Workout.Exercise.sampleKettlebellShoulderPress)
            context.insert(Workout.Exercise.sampleMachineShoulderPress)
            context.insert(Workout.Exercise.sampleMachineUnderhandRow)
            context.insert(Workout.Exercise.sampleHike)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}
