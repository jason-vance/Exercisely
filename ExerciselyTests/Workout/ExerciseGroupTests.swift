//
//  ExerciseGroupTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct ExerciseGroupTests {
    
    @Test
    func group_GroupsOneExerciseAsSet() async throws {
        let groups = ExerciseGroup.group(exercises: ExerciseGroup.sampleSingle.exercises)
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .set(let exercises):
            #expect(exercises.count == 1)
            #expect(exercises[0] == .sampleArcherPress)
        default:
            Issue.record("`firstGroup` should be `.set([.sampleYtw])`, but was `\(firstGroup)`.")
        }
    }
    
    @Test
    func group_GroupsSimpleSetAsSet() async throws {
        let groups = ExerciseGroup.group(exercises: ExerciseGroup.sampleSimpleSet.exercises)

        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .set(let activities):
            #expect(activities.count == 4)
            for activity in activities {
                #expect(activity == .sampleTurkishGetUp)
            }
        default:
            Issue.record("`firstGroup` should be `.set([.sampleYtw, .sampleYtw, .sampleYtw])`, but was `\(firstGroup)`.")
        }
    }
    
    @Test
    func group_GroupsSimpleDropSetAsDropSet() {
        let groups = ExerciseGroup.group(exercises: ExerciseGroup.sampleDropSet.exercises)
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .dropSet(let exercises):
            #expect(exercises.count == 3)
            #expect(exercises[0].name == .sampleMachineShoulderPress)
        default:
            Issue.record("`firstGroup` should be `.dropSet`, but was `\(firstGroup)`.")
        }
    }
    
    @Test
    func group_TakesRestIntoAccountWhenDecidingOnDropSet() {
        let groups = ExerciseGroup.group(exercises: ExerciseGroup.sampleFakeDropSetButItHasRests.exercises)
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .set(let exercises):
            #expect(exercises.count == 3)
            #expect(exercises[0].name == .sampleMachineShoulderPress)
        default:
            Issue.record("`firstGroup` should be `.set`, but was `\(firstGroup)`.")
        }
    }
    
    @Test
    func group_GroupsSimpleSupersetAsSuperset() {
        let groups = ExerciseGroup.group(exercises: ExerciseGroup.sampleSuperset.exercises)
        
        #expect(groups.count == 1)
        guard let firstGroup = groups.first else {
            Issue.record("`groups` should not be empty.")
            return
        }
        
        switch firstGroup {
        case .superset(let exercises, let sequenceLength):
            #expect(exercises.count == 6)
            #expect(sequenceLength == 2)
            #expect(exercises[0].name == .sampleBenchPress)
            #expect(exercises[1].name == .samplePushUps)
        default:
            Issue.record("`firstGroup` should be `.superset`, but was `\(firstGroup)`.")
        }
    }
    
    @Test
    func group_GroupsExercisesByName() async throws {
        var exercises: [Workout.Exercise] = [
            .sampleTreadmill,
            .sampleYtw, .sampleYtw,
            .sampleTrxChestStretch, .sampleTrxChestStretch,
            .sampleHike,
            .sampleShoulderTouches,
            .sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp,
            .sampleTreadmill
        ]
        exercises.append(contentsOf: ExerciseGroup.sampleDropSet.exercises)
        exercises.append(contentsOf: ExerciseGroup.sampleSuperset.exercises)

        let groups = ExerciseGroup.group(exercises: exercises)
        
        #expect(groups.count == 9)

        let treadmillGroup = groups[0]
        switch treadmillGroup {
        case .set(let exercises):
            #expect(exercises.count == 1)
            #expect(exercises[0] == .sampleTreadmill)
        default:
            Issue.record("`treadmillGroup` should be `.single(.sampleTreadmill)`, but was `\(treadmillGroup)`.")
        }
        
        let ytwGroup = groups[1]
        switch ytwGroup {
        case .set(let activities):
            #expect(activities.count == 2)
            for activity in activities {
                #expect(activity == .sampleYtw)
            }
        default:
            Issue.record("`ytwGroup` should be `.set([.sampleYtw, .sampleYtw])`, but was `\(ytwGroup)`.")
        }
        
        let trxGroup = groups[2]
        switch trxGroup {
        case .set(let activities):
            #expect(activities.count == 2)
            for activity in activities {
                #expect(activity == .sampleTrxChestStretch)
            }
        default:
            Issue.record("`trxGroup` should be `.set([.sampleTrxChestStretch, .sampleTrxChestStretch])`, but was `\(trxGroup)`.")
        }
        
        let hikeGroup = groups[3]
        switch hikeGroup {
        case .set(let exercises):
            #expect(exercises.count == 1)
            #expect(exercises[0] == .sampleHike)
        default:
            Issue.record("`hikeGroup` should be `.single(.sampleHike)`, but was `\(hikeGroup)`.")
        }
        
        let shoulderTouchGroup = groups[4]
        switch shoulderTouchGroup {
        case .set(let exercises):
            #expect(exercises.count == 1)
            #expect(exercises[0] == .sampleShoulderTouches)
        default:
            Issue.record("`shoulderTouchGroup` should be `.single(.sampleShoulderTouches)`, but was `\(shoulderTouchGroup)`.")
        }
        
        let turkishGroup = groups[5]
        switch turkishGroup {
        case .set(let activities):
            #expect(activities.count == 3)
            for activity in activities {
                #expect(activity == .sampleTurkishGetUp)
            }
        default:
            Issue.record("`turkishGroup` should be `.set([.sampleTurkishGetUp, .sampleTurkishGetUp, .sampleTurkishGetUp])`, but was `\(turkishGroup)`.")
        }
        
        let treadmill2Group = groups[6]
        switch treadmill2Group {
        case .set(let exercises):
            #expect(exercises.count == 1)
            #expect(exercises[0] == .sampleTreadmill)
        default:
            Issue.record("`treadmill2Group` should be `.single(.sampleTreadmill)`, but was `\(treadmill2Group)`.")
        }
        
        let dropSetGroup = groups[7]
        switch dropSetGroup {
        case .dropSet(let exercises):
            #expect(exercises.count == 3)
            #expect(exercises[0].name == Workout.Exercise.sampleMachineShoulderPress.name)
        default:
            Issue.record("`dropSetGroup` should be `.dropSet`, but was `\(dropSetGroup)`.")
        }
        
        let supersetGroup = groups[8]
        switch supersetGroup {
        case .superset(let exercises, let sequenceLength):
            #expect(exercises.count == 6)
            #expect(sequenceLength == 2)
            #expect(exercises[0].name == .sampleBenchPress)
            #expect(exercises[1].name == .samplePushUps)
        default:
            Issue.record("`supersetGroup` should be `.superset`, but was `\(supersetGroup)`.")
        }
    }

}
