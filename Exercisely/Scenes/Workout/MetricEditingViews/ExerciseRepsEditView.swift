//
//  ExerciseRepsEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/14/25.
//

import SwiftUI
import SwiftData

struct ExerciseRepsEditView: View {
    
    @Environment(\.presentationMode) var presentation
        
    @Query private var exercises: [Workout.Exercise]
    
    @Binding var reps: Workout.Exercise.Reps?

    @State private var repsInt: Int = 0
    
    init(reps: Binding<Workout.Exercise.Reps?>) {
        self._reps = reps
    }
    
    private var suggestions: [Int] {
        var suggestions = exercises
            .compactMap { $0.reps?.count }
            .filter { $0 > 9 }
        suggestions.append(contentsOf: [10,12,15,18])

        return Set(suggestions).sorted { $0 < $1 }
    }
    
    private func saveExerciseReps() {
        let reps = Workout.Exercise.Reps(repsInt)
        self.reps = reps
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            RepsField()
            Spacer()
            Keyboard()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: reps, initial: true) { _, newValue in
            repsInt = reps?.count ?? 0
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Reps")
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
            saveExerciseReps()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func RepsField() -> some View {
        Section {
            let reps = Workout.Exercise.Reps(repsInt)
            
            HStack {
                Spacer(minLength: 0)
                Text(reps == nil ? "N/A" : "\(reps!.count)")
                    .font(.largeTitle)
                    .bold()
                Spacer(minLength: 0)
            }
            .workoutExerciseRow()
        } header: {
            SectionHeader("Reps")
        }
    }
    
    @ViewBuilder private func Keyboard() -> some View {
        let suggestions = suggestions
        
        VStack(spacing: .padding) {
            HStack(spacing: .padding) {
                NumberButton(1)
                NumberButton(2)
                NumberButton(3)
                NumberButton(suggestions[0], isSuggestion: true)
            }
            HStack(spacing: .padding) {
                NumberButton(4)
                NumberButton(5)
                NumberButton(6)
                NumberButton(suggestions[1], isSuggestion: true)
            }
            HStack(spacing: .padding) {
                NumberButton(7)
                NumberButton(8)
                NumberButton(9)
                NumberButton(suggestions[2], isSuggestion: true)
            }
            HStack(spacing: .padding) {
                BackspaceButton()
                NumberButton(0)
                NumberButton(0)
                    .hidden()
                NumberButton(suggestions[3], isSuggestion: true)
            }
        }
        .padding()
    }
    
    @ViewBuilder private func NumberButton(_ number: Int, isSuggestion: Bool = false) -> some View {
        Button {
            if isSuggestion {
                repsInt = number
            } else {
                repsInt *= 10
                repsInt += number
            }
        } label: {
            ZStack {
                if isSuggestion {
                    Circle()
                        .foregroundColor(Color.text)
                        .aspectRatio(1.0, contentMode: .fit)
                } else {
                    Circle()
                        .stroke(style: .init(lineWidth: 1))
                        .foregroundColor(Color.accentColor)
                        .aspectRatio(1.0, contentMode: .fit)
                }
                Text("\(number)")
                    .keyboardButton(isSuggestion: isSuggestion)
            }
        }
    }
    
    @ViewBuilder private func BackspaceButton() -> some View {
        Button {
            repsInt /= 10
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Image(systemName: "delete.backward")
                    .keyboardButton()
            }
        }
    }
}

fileprivate extension View {
    func keyboardButton(isSuggestion: Bool = false) -> some View {
        self
            .font(.title)
            .bold(isSuggestion)
            .foregroundColor(isSuggestion ? Color.background : Color.text)
    }
}

#Preview {
    var reps: Workout.Exercise.Reps? = nil
//    var reps: Workout.Exercise.Reps? = .init(5)

    NavigationStack {
        ExerciseRepsEditView(
            reps: .init(
                get: { reps },
                set: { reps = $0; print("Reps: \(String(describing: $0?.formatted()))") }
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
