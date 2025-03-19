//
//  ArrayExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 3/18/25.
//

import Foundation

extension Array {
    func every(nth: Int) -> [Element] {
        guard nth > 0 else { return [] } // Prevent division by zero or negative values
        return stride(from: 0, to: count, by: nth).map { self[$0] }
    }
}
