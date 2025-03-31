//
//  BirthDate.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import Foundation

final class BirthDate {
    
    static var today: BirthDate { .init(date: .today)! }
    
    let date: SimpleDate
    
    init?(date: SimpleDate) {
        guard date.adding(years: 13) < .today else {
            return nil
        }
        
        self.date = date
    }
    
    convenience init?(rawValue: Int) {
        guard rawValue > 0 else {
            return nil
        }
        guard let date = SimpleDate(rawValue: SimpleDate.RawValue(rawValue)) else {
            return nil
        }
        
        self.init(date: date)
    }
    
    func formatted() -> String {
        date.formatted()
    }
}
