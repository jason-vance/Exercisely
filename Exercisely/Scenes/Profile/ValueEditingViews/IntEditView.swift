//
//  IntEditView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import SwiftUI

struct IntEditView: View {
    
    @Environment(\.presentationMode) var presentation
        
    private let navigationBarTitle: String
    @Binding var int: Int?

    @State private var valueString: String = ""
    
    init(int: Binding<Int?>, navigationBarTitle: String) {
        self._int = int
        self.navigationBarTitle = navigationBarTitle
    }
    
    private var value: Int? {
        Int(valueString)
    }
    
    private func saveValue() {
        if let value = value {
            self.int = value
        } else {
            self.int = nil
        }
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            ValueField()
            Spacer()
            Keyboard()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: int, initial: true) { _, newValue in
            valueString = newValue == nil ? "" : "\(newValue!.formatted())"
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(navigationBarTitle)
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
            saveValue()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func ValueField() -> some View {
        Section {
            HStack {
                Spacer(minLength: 0)
                if valueString.isEmpty {
                    Text("N/A")
                } else {
                    Text(valueString)
                }
                Spacer(minLength: 0)
            }
            .font(.largeTitle)
            .bold()
            .workoutExerciseRow()
        } header: {
            SectionHeader(navigationBarTitle)
        }
    }
    
    @ViewBuilder private func Keyboard() -> some View {
        VStack(spacing: .padding) {
            HStack(spacing: .padding) {
                Spacer()
                NumberButton(1)
                NumberButton(2)
                NumberButton(3)
                Spacer()
            }
            HStack(spacing: .padding) {
                Spacer()
                NumberButton(4)
                NumberButton(5)
                NumberButton(6)
                Spacer()
            }
            HStack(spacing: .padding) {
                Spacer()
                NumberButton(7)
                NumberButton(8)
                NumberButton(9)
                Spacer()
            }
            HStack(spacing: .padding) {
                Spacer()
                BackspaceButton()
                NumberButton(0)
                NumberButton(0)
                    .hidden()
                Spacer()
            }
        }
        .padding()
    }
    
    @ViewBuilder private func NumberButton(_ number: Int) -> some View {
        Button {
            valueString += "\(number)"
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .frame(width: 80, height: 80)
                Text("\(number.formatted())")
                    .keyboardButton()
            }
        }
    }
    
    @ViewBuilder private func BackspaceButton() -> some View {
        Button {
            guard !valueString.isEmpty else { return }
            valueString.removeLast()
        } label: {
            ZStack {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color.accentColor)
                    .frame(width: 80, height: 80)
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
//    var value: Int? = nil
    var value: Int? = 5

    NavigationStack {
        IntEditView(
            int: .init(
                get: { value },
                set: { value = $0; print("Value: \(String(describing: $0?.formatted()))") }
            ),
            navigationBarTitle: "Some Int Value"
        )
    }
}
