//
//  FieldCaption.swift
//  Exercisely
//
//  Created by Jason Vance on 3/18/25.
//

import SwiftUI

struct FieldCaption: View {
    
    private let text: String
    private let isError: Bool
    
    init(_ text: String, isError: Bool = false) {
        self.text = text
        self.isError = isError
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(isError ? Color.red : Color.text)
        .contentTransition(.numericText())
        .animation(.snappy, value: text)
        .animation(.snappy, value: isError)
    }
}

#Preview {
    List {
        VStack {
            Text(Workout.Exercise.Name.prompt.formatted())
            .fieldButton()
            FieldCaption("Hello")
        }
        .workoutExerciseRow()
        VStack {
            Text(Workout.Exercise.Name.prompt.formatted())
            .fieldButton()
            FieldCaption("Hello", isError: true)
        }
        .workoutExerciseRow()
    }
    .listDefaultModifiers()
}
