//
//  MuscleDiagram.swift
//  Exercisely
//
//  Created by Jason Vance on 4/21/25.
//

import SwiftUI

struct MuscleDiagram: View {
    
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    
    var body: some View {
        ZStack {
            ForEach(secondaryMuscles, id: \.self) { muscle in
                Image(muscle)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.accentLight)
            }
            ForEach(primaryMuscles, id: \.self) { muscle in
                Image(muscle)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.accentColor)
            }
            Image("Outline")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.text)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MuscleDiagram(
        primaryMuscles: ["Chest", "Back", "Shoulders"],
        secondaryMuscles: ["Triceps", "Biceps", "Forearms"]
    )
}
