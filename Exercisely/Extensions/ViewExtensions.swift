//
//  ViewExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation
import SwiftUI

extension View {
    
    func navigationBarTitle() -> some View {
        self
            .bold(true)
            .foregroundStyle(Color.text)
    }
    
    func underlined(_ color: Color = Color.accentColor) -> some View {
        self
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(color)
            }
    }
    
    func overlined(_ color: Color = Color.accentColor, lineHeight: CGFloat = 1) -> some View {
        self
            .overlay(alignment: .top) {
                Rectangle()
                    .frame(height: lineHeight)
                    .foregroundStyle(color)
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
            .font(.subheadline)
            .foregroundColor(Color.text)
            .padding(.horizontal, .padding)
            .padding(.vertical, .padding / 2)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: .buttonCornerRadius, style: .continuous)
                        .foregroundStyle(Color.background)
                    RoundedRectangle(cornerRadius: .buttonCornerRadius, style: .continuous)
                        .stroke(style: .init(lineWidth: 1))
                        .foregroundStyle(Color.accentColor)
                }
            }
    }
    
    func toolbarCircleButton() -> some View {
        self
            .font(.caption)
            .foregroundColor(Color.text)
            .frame(width: 24, height: 24)
            .background {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(Color.accentColor)
            }
    }
    
    func fabButton(diminished: Bool = false) -> some View {
        self
            .font(diminished ? .subheadline : .title)
            .foregroundColor(Color.text)
            .frame(
                width: diminished ? 36 : 64,
                height: diminished ? 36 : 64
            )
            .background {
                ZStack {
                    Circle()
                        .foregroundStyle(Color.background)
                        .shadow(color: Color.text.opacity(diminished ? 0 : 0.33), radius: 4)
                    Circle()
                        .stroke(style: .init(lineWidth: 1))
                        .foregroundStyle(Color.accentColor)
                }
            }
    }
    
    func fieldLabel() -> some View {
        self
            .font(.subheadline)
    }
    
    func fieldButton() -> some View {
        self
            .foregroundStyle(Color.text)
            .bold()
            .underlined()
    }
    
    func listRowNoChrome() -> some View {
        self
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func workoutSectionHeader() -> some View {
        self
            .font(.title3)
            .textCase(.uppercase)
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

