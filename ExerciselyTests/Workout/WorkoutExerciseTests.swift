//
//  WorkoutExerciseTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct WorkoutExerciseTests {
    
    @Test func group_GroupsOneExerciseAsSingleExerciseGroup() async throws {
        let groups = Workout.Exercise.group(exercises: [.sampleYtw])
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .single(let activity):
            #expect(activity == .sampleYtw)
        default:
            Issue.record("`firstGroup` should be `.single(.sampleYtw)`, but was something else.")
        }
    }
    
    @Test func group_GroupsSimpleSetAsSetExerciseGroup() async throws {
        let groups = Workout.Exercise.group(exercises: [.sampleYtw, .sampleYtw, .sampleYtw])
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .set(let activities):
            #expect(activities.count == 3)
            for activity in activities {
                #expect(activity == .sampleYtw)
            }
        default:
            Issue.record("`firstGroup` should be `.set([.sampleYtw, .sampleYtw, .sampleYtw])`, but was something else.")
        }
    }
    
    @Test func group_GroupsExercisesByName() async throws {
        let groups = Workout.Exercise.group(exercises: [
            .sampleTreadmill,
            .sampleYtw, .sampleYtw,
            .sampleTrxChestStretch, .sampleTrxChestStretch,
            .sampleHike,
            .sampleShoulderTouches,
            .sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp,
            .sampleTreadmill
        ])
        
        #expect(groups.count == 7)

        let treadmillGroup = groups[0]
        switch treadmillGroup {
        case .single(let activity):
            #expect(activity == .sampleTreadmill)
        default:
            Issue.record("`treadmillGroup` should be `.single(.sampleTreadmill)`, but was something else.")
        }
        
        let ytwGroup = groups[1]
        switch ytwGroup {
        case .set(let activities):
            #expect(activities.count == 2)
            for activity in activities {
                #expect(activity == .sampleYtw)
            }
        default:
            Issue.record("`ytwGroup` should be `.set([.sampleYtw, .sampleYtw])`, but was something else.")
        }
        
        let trxGroup = groups[2]
        switch trxGroup {
        case .set(let activities):
            #expect(activities.count == 2)
            for activity in activities {
                #expect(activity == .sampleTrxChestStretch)
            }
        default:
            Issue.record("`trxGroup` should be `.set([.sampleTrxChestStretch, .sampleTrxChestStretch])`, but was something else.")
        }
        
        let hikeGroup = groups[3]
        switch hikeGroup {
        case .single(let activity):
            #expect(activity == .sampleHike)
        default:
            Issue.record("`hikeGroup` should be `.single(.sampleHike)`, but was something else.")
        }
        
        let shoulderTouchGroup = groups[4]
        switch shoulderTouchGroup {
        case .single(let activity):
            #expect(activity == .sampleShoulderTouches)
        default:
            Issue.record("`shoulderTouchGroup` should be `.single(.sampleShoulderTouches)`, but was something else.")
        }
        
        let turkishGroup = groups[5]
        switch turkishGroup {
        case .set(let activities):
            #expect(activities.count == 3)
            for activity in activities {
                #expect(activity == .sampleTurkishGetUp)
            }
        default:
            Issue.record("`turkishGroup` should be `.set([.sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp])`, but was something else.")
        }
        
        let treadmill2Group = groups[6]
        switch treadmill2Group {
        case .single(let activity):
            #expect(activity == .sampleTreadmill)
        default:
            Issue.record("`treadmill2Group` should be `.single(.sampleTreadmill)`, but was something else.")
        }
    }

}
