//
//  DistanceTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct DistanceTests {
    
    @Test func equivalentDistancesAreEqual() async throws {
        #expect(Distance(value: 1, unit: .feet) == Distance(value: 1, unit: .feet))
        #expect(Distance(value: 1, unit: .feet) == Distance(value: 0.3048, unit: .meters))
        #expect(Distance(value: 1, unit: .feet) == Distance(value: 0.000189394, unit: .miles))
        #expect(Distance(value: 1, unit: .feet) == Distance(value: 0.0003048, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .meters) == Distance(value: 3.28084, unit: .feet))
        #expect(Distance(value: 1, unit: .meters) == Distance(value: 1, unit: .meters))
        #expect(Distance(value: 1, unit: .meters) == Distance(value: 0.000621371, unit: .miles))
        #expect(Distance(value: 1, unit: .meters) == Distance(value: 0.001, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .miles) == Distance(value: 5280, unit: .feet))
        #expect(Distance(value: 1, unit: .miles) == Distance(value: 1609.34, unit: .meters))
        #expect(Distance(value: 1, unit: .miles) == Distance(value: 1, unit: .miles))
        #expect(Distance(value: 1, unit: .miles) == Distance(value: 1.60934, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .kilometers) == Distance(value: 3280.84, unit: .feet))
        #expect(Distance(value: 1, unit: .kilometers) == Distance(value: 1000, unit: .meters))
        #expect(Distance(value: 1, unit: .kilometers) == Distance(value: 0.621371, unit: .miles))
        #expect(Distance(value: 1, unit: .kilometers) == Distance(value: 1, unit: .kilometers))
    }

    @Test func nonEquivalentDistancesAreNotEqual() async throws {
        #expect(Distance(value: 1, unit: .feet) != Distance(value: 2, unit: .feet))
        #expect(Distance(value: 1, unit: .feet) != Distance(value: 2, unit: .meters))
        #expect(Distance(value: 1, unit: .feet) != Distance(value: 2, unit: .miles))
        #expect(Distance(value: 1, unit: .feet) != Distance(value: 2, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .meters) != Distance(value: 2, unit: .feet))
        #expect(Distance(value: 1, unit: .meters) != Distance(value: 2, unit: .meters))
        #expect(Distance(value: 1, unit: .meters) != Distance(value: 2, unit: .miles))
        #expect(Distance(value: 1, unit: .meters) != Distance(value: 2, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .miles) != Distance(value: 2, unit: .feet))
        #expect(Distance(value: 1, unit: .miles) != Distance(value: 2, unit: .meters))
        #expect(Distance(value: 1, unit: .miles) != Distance(value: 2, unit: .miles))
        #expect(Distance(value: 1, unit: .miles) != Distance(value: 2, unit: .kilometers))
        
        #expect(Distance(value: 1, unit: .kilometers) != Distance(value: 2, unit: .feet))
        #expect(Distance(value: 1, unit: .kilometers) != Distance(value: 2, unit: .meters))
        #expect(Distance(value: 1, unit: .kilometers) != Distance(value: 2, unit: .miles))
        #expect(Distance(value: 1, unit: .kilometers) != Distance(value: 2, unit: .kilometers))
    }
    
    @Test func formatsCorrectly() {
        #expect(Distance(value: 10, unit: .kilometers)!.formatted() == "10km")
        #expect(Distance(value: 12.5, unit: .miles)!.formatted() == "12.5mi")
        #expect(Distance(value: 15, unit: .meters)!.formatted() == "15m")
        #expect(Distance(value: 17.5, unit: .feet)!.formatted() == "17.5ft")
    }
    
    @Test
    func classFormattedFormatsCorrectly() async throws {
        var x = Distance.formatted([
            .init(value: 10, unit: .meters),
            .init(value: 10, unit: .meters),
            .init(value: 10, unit: .meters),
        ])
        #expect(x == "10m")
        
        x = Distance.formatted([
            .init(value: 10, unit: .feet),
            .init(value: 12, unit: .feet),
            .init(value: 15, unit: .feet),
        ])
        #expect(x == "10,12,15ft")
        
        x = Distance.formatted([
            .init(value: 10, unit: .miles),
            nil,
            .init(value: 15, unit: .miles),
        ])
        #expect(x == "10,-,15mi")
        
        x = Distance.formatted([
            .init(value: 10, unit: .kilometers),
            nil,
            .init(value: 10, unit: .kilometers),
        ])
        #expect(x == "10,-,10km")
        
        x = Distance.formatted([
            nil,
            nil,
            nil,
        ])
        #expect(x == "??mi")
        
        x = Distance.formatted([
            .init(value: 10, unit: .miles),
            .init(value: 10, unit: .kilometers),
        ])
        #expect(x == "10mi,10km")
        
        x = Distance.formatted([
            .init(value: 10, unit: .feet),
            nil,
            .init(value: 10, unit: .meters),
        ])
        #expect(x == "10ft,-,10m")
    }
}
