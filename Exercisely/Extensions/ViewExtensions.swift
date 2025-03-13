//
//  ViewExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation
import SwiftUI

extension View {
    
    func listRowNoChrome() -> some View {
        self
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func workoutSectionHeader() -> some View {
        self
            .font(.headline)
            .bold()
    }
    
    func workoutActivityRow() -> some View {
        self
            .listRowNoChrome()
            .padding(.leading, 30)
            .listRowInsets(.init(top: 0,
                                 leading: 12,
                                 bottom: 0,
                                 trailing: 12))
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

