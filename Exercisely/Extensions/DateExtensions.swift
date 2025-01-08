//
//  DateExtensions.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation

extension Date {
    func toBasicUiString() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today"
        }
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow"
        }
        return self.formatted(date: .abbreviated, time: .omitted)
    }
}
