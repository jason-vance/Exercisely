//
//  DoubleExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
