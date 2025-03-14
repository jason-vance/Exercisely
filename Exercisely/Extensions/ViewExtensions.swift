//
//  ViewExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation
import SwiftUI

extension View {
    
    func underlined() -> some View {
        self
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.accentColor)
            }
    }
    
    func listDefaultModifiers() -> some View {
        self
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(Color.background)
    }
    
    func buttonDefaultModifiers() -> some View {
        self
            .padding(.horizontal, .padding)
            .padding(.vertical, .padding / 2)
            .foregroundColor(Color.text)
            .background {
                RoundedRectangle(cornerRadius: .cornerRadiusDefault, style: .continuous)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(Color.accentColor)
            }
    }
    
    func listRowNoChrome() -> some View {
        self
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func workoutSectionHeader() -> some View {
        self
            .font(.title3)
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.text)
    }
    
    func workoutExerciseRow() -> some View {
        self
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.text)
            .listRowNoChrome()
    }
    
    func workoutExerciseDataItem() -> some View {
        self
            .font(.caption)
            .foregroundStyle(Color.text)
    }
    
    func workoutSetsCountOverlay(setsCount: Int, exerciseCount: Int) -> some View {
        self
            .overlay(alignment: .bottomLeading) {
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                        .stroke(style: .init(lineWidth: 1))
                        .frame(width: 18, height: 18 + (CGFloat(exerciseCount - 1) * 45))
                    if setsCount > 1 {
                        Text("\(setsCount)x")
                            .font(.caption2)
                    }
                }
            }
    }
}

