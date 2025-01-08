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
    
    func workoutActivityRow() -> some View {
        self
            .listRowNoChrome()
            .padding(.leading, 30)
            .listRowInsets(.init(top: 0,
                                 leading: 12,
                                 bottom: 0,
                                 trailing: 12))
    }
}

