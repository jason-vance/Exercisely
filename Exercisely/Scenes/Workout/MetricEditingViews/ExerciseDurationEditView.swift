//
//  ExerciseDurationEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct ExerciseDurationEditView: View {
    
    @Environment(\.presentationMode) var presentation
        
    @Binding var duration: Workout.Exercise.Duration?

    @State private var durationValueString: String = ""
    @State private var durationUnit: Workout.Exercise.Duration.Unit = .seconds
    
    @State private var dotPressed: Bool = false

    init(duration: Binding<Workout.Exercise.Duration?>) {
        self._duration = duration
    }
    
    private var durationValue: Double? {
        Double(durationValueString)
    }
    
    private func saveExerciseDuration() {
        if let durationValue = durationValue {
            self.duration = .init(value: durationValue, unit: durationUnit)
        } else {
            self.duration = nil
        }
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            DurationField()
            Spacer()
            Keyboard()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: duration, initial: true) { _, newValue in
            durationValueString = newValue == nil ? "" : "\(newValue!.value.formatted())"
            durationUnit = newValue?.unit ?? .seconds
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Duration")
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
            saveExerciseDuration()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func DurationField() -> some View {
        Section {
            HStack {
                Spacer(minLength: 0)
                if durationValueString.isEmpty {
                    Text("N/A")
                } else {
                    Text(durationValueString)
                    Text(durationUnit.formatted())
                }
                Spacer(minLength: 0)
            }
            .font(.largeTitle)
            .bold()
            .workoutExerciseRow()
        } header: {
            SectionHeader("Duration")
        }
    }
    
    @ViewBuilder private func Keyboard() -> some View {
        VStack(spacing: .padding) {
            HStack(spacing: .padding) {
                NumberButton(1)
                NumberButton(2)
                NumberButton(3)
                UnitsButton()
            }
            HStack(spacing: .padding) {
                NumberButton(4)
                NumberButton(5)
                NumberButton(6)
                UnitsButton()
                    .hidden()
            }
            HStack(spacing: .padding) {
                NumberButton(7)
                NumberButton(8)
                NumberButton(9)
                UnitsButton()
                    .hidden()
            }
            HStack(spacing: .padding) {
                ClearButton()
                NumberButton(0)
                DotButton()
                BackspaceButton()
            }
        }
        .padding()
    }
    
    @ViewBuilder private func NumberButton(_ number: Int) -> some View {
        Button {
            durationValueString += "\(number)"
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text("\(number.formatted())")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func UnitsButton() -> some View {
        Menu {
            Button("Seconds") { durationUnit = .seconds }
            Button("Minutes") { durationUnit = .minutes }
            Button("Hours") { durationUnit = .hours }
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text(durationUnit.formatted())
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func DotButton() -> some View {
        Button {
            if !durationValueString.contains(".") && durationValueString != "-" {
                durationValueString.append(".")
            }
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text(".")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func ClearButton() -> some View {
        Button {
            durationValueString = ""
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text("N/A")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func BackspaceButton() -> some View {
        Button {
            guard !durationValueString.isEmpty else { return }
            durationValueString.removeLast()
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
//    var duration: Workout.Exercise.Duration? = nil
    var duration: Workout.Exercise.Duration? = .init(value: 30, unit: .seconds)

    NavigationStack {
        ExerciseDurationEditView(
            duration: .init(
                get: { duration },
                set: { duration = $0; print("Duration: \(String(describing: $0?.formatted()))") }
            )
        )
    }
}
