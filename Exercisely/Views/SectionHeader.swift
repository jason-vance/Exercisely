//
//  SectionHeader.swift
//  Exercisely
//
//  Created by Jason Vance on 3/14/25.
//

import SwiftUI

struct SectionHeader: View {
    
    @State var text: String
    
    init(_ text: String) {
        _text = .init(initialValue: text)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(text)
            Text(":")
        }
        .workoutSectionHeader()
    }
}

#Preview {
    List{
        Section {
            
        } header: {
            SectionHeader("Focus")
        }
    }
}
