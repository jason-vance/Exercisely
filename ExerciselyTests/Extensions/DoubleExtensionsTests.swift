//
//  DoubleExtensionsTests.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct DoubleExtensionsTests {
    
    @Test func roundsCorrectly() {
        #expect(1.23456789.rounded(to: 2) == 1.23)
        #expect(1.23456789.rounded(to: 5) == 1.23457)
        #expect(1.23456789.rounded(to: 10) == 1.23456789)
    }
}
