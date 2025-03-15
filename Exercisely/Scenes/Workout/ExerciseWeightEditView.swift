//
//  ExerciseWeightEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/14/25.
//

import SwiftUI

struct ExerciseWeightEditView: View {
    
    @Environment(\.presentationMode) var presentation
        
    @Binding var weight: Weight?

    @State private var weightValueString: String = ""
    @State private var weightUnit: Weight.Unit = .pounds
    
    @State private var dotPressed: Bool = false

    init(weight: Binding<Weight?>) {
        self._weight = weight
    }
    
    private var weightValue: Double? {
        Double(weightValueString)
    }
    
    private func saveExerciseWeight() {
        if let weightValue = weightValue {
            self.weight = Weight(value: weightValue, unit: weightUnit)
        } else {
            self.weight = nil
        }
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            WeightField()
            Spacer()
            Keyboard()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: weight, initial: true) { _, newValue in
            weightValueString = weight == nil ? "" : "\(weight!.value.formatted())"
            weightUnit = weight?.unit ?? .pounds
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Weight")
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
            saveExerciseWeight()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func WeightField() -> some View {
        Section {
            HStack {
                Spacer(minLength: 0)
                if weightValueString.isEmpty {
                    Text("N/A")
                } else {
                    Text(weightValueString)
                    Text(weightUnit.formatted())
                }
                Spacer(minLength: 0)
            }
            .font(.largeTitle)
            .bold()
            .overlay(alignment: .bottom) {
                Group {
                    if weightValueString.first == "-" {
                        Text("An Assisted Exercise")
                    } else if !weightValueString.isEmpty {
                        Text("A Weighted Exercise")
                    }
                }
                .font(.footnote)
                .bold()
                .opacity(0.5)
                .offset(y: .padding)
            }
            .workoutExerciseRow()
        } header: {
            SectionHeader("Weight")
        }
    }
    
    @ViewBuilder private func Keyboard() -> some View {
        VStack(spacing: .padding) {
            HStack(spacing: .padding) {
                NumberButton(1)
                NumberButton(2)
                NumberButton(3)
                PoundsButton()
            }
            HStack(spacing: .padding) {
                NumberButton(4)
                NumberButton(5)
                NumberButton(6)
                KilogramsButton()
            }
            HStack(spacing: .padding) {
                NumberButton(7)
                NumberButton(8)
                NumberButton(9)
                NegativeButton()
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
            weightValueString += "\(number)"
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
    
    @ViewBuilder private func PoundsButton() -> some View {
        Button {
            weightUnit = .pounds
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text("Lbs")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func KilogramsButton() -> some View {
        Button {
            weightUnit = .kilograms
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text("Kg")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func NegativeButton() -> some View {
        Button {
            if weightValueString.first == "-" {
                weightValueString.remove(at: weightValueString.startIndex)
            } else {
                weightValueString.insert("-", at: weightValueString.startIndex)
            }
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .aspectRatio(1.0, contentMode: .fit)
                Text(weightValueString.first == "-" ? "+" : "-")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func DotButton() -> some View {
        Button {
            if !weightValueString.contains(".") && weightValueString != "-" {
                weightValueString.append(".")
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
            weightValueString = ""
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
            guard !weightValueString.isEmpty else { return }
            weightValueString.removeLast()
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
//    var weight: Weight? = nil
    var weight: Weight? = .init(value: 95, unit: .pounds)

    NavigationStack {
        ExerciseWeightEditView(
            weight: .init(
                get: { weight },
                set: { weight = $0; print("Weight: \(String(describing: $0?.formatted()))") }
            )
        )
    }
}
