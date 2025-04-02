//
//  ExerciseDistanceEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct ExerciseDistanceEditView: View {
    
    @Environment(\.presentationMode) var presentation
        
    @Binding var distance: Distance?

    @State private var distanceValueString: String = ""
    @State private var distanceUnit: Distance.Unit = .miles
    
    init(distance: Binding<Distance?>) {
        self._distance = distance
    }
    
    private var distanceValue: Double? {
        Double(distanceValueString)
    }
    
    private func saveExerciseDistance() {
        if let distanceValue = distanceValue {
            self.distance = Distance(value: distanceValue, unit: distanceUnit)
        } else {
            self.distance = nil
        }
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            DistanceField()
            Spacer()
            Keyboard()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: distance, initial: true) { _, newValue in
            distanceValueString = newValue == nil ? "" : "\(newValue!.value.formatted())"
            distanceUnit = newValue?.unit ?? .miles
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Distance")
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
            presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func SaveButton() -> some View {
        Button {
            saveExerciseDistance()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        Section {
            HStack {
                Spacer(minLength: 0)
                if distanceValueString.isEmpty {
                    Text("N/A")
                } else {
                    Text(distanceValueString)
                    Text(distanceUnit.formatted())
                }
                Spacer(minLength: 0)
            }
            .font(.largeTitle)
            .bold()
            .workoutExerciseRow()
        } header: {
            SectionHeader("Distance")
        }
    }
    
    @ViewBuilder private func Keyboard() -> some View {
        VStack(spacing: .padding) {
            HStack(spacing: .padding) {
                NumberButton(1)
                NumberButton(2)
                NumberButton(3)
                UnitButton(.miles)
            }
            HStack(spacing: .padding) {
                NumberButton(4)
                NumberButton(5)
                NumberButton(6)
                UnitButton(.kilometers)
            }
            HStack(spacing: .padding) {
                NumberButton(7)
                NumberButton(8)
                NumberButton(9)
                UnitButton(.meters)
            }
            HStack(spacing: .padding) {
                BackspaceButton()
                NumberButton(0)
                DotButton()
                UnitButton(.feet)
            }
        }
        .padding()
    }
    
    @ViewBuilder private func NumberButton(_ number: Int) -> some View {
        Button {
            distanceValueString += "\(number)"
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
    
    @ViewBuilder private func UnitButton(_ unit: Distance.Unit) -> some View {
        Button {
            distanceUnit = unit
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.text)
                    .aspectRatio(1.0, contentMode: .fit)
                Text("\(unit.formatted())")
                    .keyboardButton(isSuggestion: true)
            }
        }
    }
    
    @ViewBuilder private func DotButton() -> some View {
        Button {
            if !distanceValueString.contains(".") && distanceValueString != "-" {
                distanceValueString.append(".")
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
    
    @ViewBuilder private func BackspaceButton() -> some View {
        Button {
            guard !distanceValueString.isEmpty else { return }
            distanceValueString.removeLast()
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
//    var distance: Distance? = nil
    var distance: Distance? = .init(value: 5, unit: .miles)

    NavigationStack {
        ExerciseDistanceEditView(
            distance: .init(
                get: { distance },
                set: { distance = $0; print("Distance: \(String(describing: $0?.formatted()))") }
            )
        )
    }
}
