//
//  ExerciseEntryDetailView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/1/25.
//

import SwiftUI

//TODO: Add a muscle map/diagram that shows the muscles worked
//TODO: Re-order and make it look better (consolidate sets/reps)
//TODO: Add links to associated exercises
//TODO: Add links to muscles worked
//TODO: Add links to exercise types
//TODO: Add links to equipment
//TODO: Add links to body areas
struct ExerciseEntryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    public let entry: ExerciseEntry
    
    var body: some View {
        List {
            YouTubeShortSection()
            AssociatedExercisesSection()
            RecommendedRepsSection()
            RecommendedSetsSection()
            SafetyWarningsSection()
            VariationsSection()
            TrainerTipsSection()
            CommonMistakesSection()
            DifficultySection()
            ExerciseTypeSection()
            EquipmentSection()
            AlternativeNamesSection()
            PrimaryMusclesWorkedSection()
            SecondaryMusclesWorkedSection()
            BodyAreasTargetedSection()
            PerformanceStepsSection()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(entry.name)
                .navigationBarTitle()
        }
        ToolbarItem(placement: .navigationBarLeading) {
            CloseButton()
        }
    }
    
    @ViewBuilder private func CloseButton() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        }
    }
    
    @ViewBuilder private func YouTubeShortSection() -> some View {
        if let youtubeShortUrl = entry.youtubeShortUrl {
            Section {
                YouTubeShortView(youtubeShortUrl: youtubeShortUrl)
                    .workoutExerciseRow()
            } header: {
                Text("Video Guide")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func AssociatedExercisesSection() -> some View {
        if !entry.associatedExercises.isEmpty {
            Section {
                ForEach(entry.associatedExercises, id: \.self) { exercise in
                    Text(exercise)
                        .workoutExerciseRow()
                }
            } header: {
                Text("Associated Exercises")
                    .librarySectionHeader()
            }
        }
    }

    
    @ViewBuilder private func RecommendedRepsSection() -> some View {
        Section {
            VStack {
                if entry.recommendedMinReps != entry.recommendedMaxReps {
                    Text("\(entry.recommendedMinReps)-\(entry.recommendedMaxReps)")
                } else {
                    Text("\(entry.recommendedMinReps)")
                }
            }
            .workoutExerciseRow()
        } header: {
            Text("Recommended Reps")
                .librarySectionHeader()
        }
    }
    
    @ViewBuilder private func RecommendedSetsSection() -> some View {
        Section {
            VStack {
                if entry.recommendedMinSets != entry.recommendedMaxSets {
                    Text("\(entry.recommendedMinSets)-\(entry.recommendedMaxSets)")
                } else {
                    Text("\(entry.recommendedMinSets)")
                }
            }
            .workoutExerciseRow()
        } header: {
            Text("Recommended Sets")
                .librarySectionHeader()
        }
    }
    
    @ViewBuilder private func SafetyWarningsSection() -> some View {
        if !entry.safetyWarnings.isEmpty {
            Section {
                ForEach(entry.safetyWarnings, id: \.self) { warning in
                    Text(warning)
                        .workoutExerciseRow()
                }
            } header: {
                Text("Safety Warnings")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func VariationsSection() -> some View {
        if !entry.variations.isEmpty {
            Section {
                Text(entry.variations.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Variations & Alternatives")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func TrainerTipsSection() -> some View {
        if !entry.trainerTips.isEmpty {
            Section {
                ForEach(entry.trainerTips, id: \.self) { tip in
                    Text(tip)
                        .workoutExerciseRow()
                }
            } header: {
                Text("Trainer Tips")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func CommonMistakesSection() -> some View {
        if !entry.commonMistakes.isEmpty {
            Section {
                ForEach(entry.commonMistakes, id: \.self) { mistake in
                    Text(mistake)
                        .workoutExerciseRow()
                }
            } header: {
                Text("Common Mistakes")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func DifficultySection() -> some View {
        if !entry.difficulty.isEmpty {
            Section {
                Text(entry.difficulty)
                    .workoutExerciseRow()
            } header: {
                Text("Difficulty")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func ExerciseTypeSection() -> some View {
        if !entry.exerciseType.isEmpty {
            Section {
                Text(entry.exerciseType.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Exercise Type")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func AlternativeNamesSection() -> some View {
        if !entry.alternateNames.isEmpty {
            Section {
                Text(entry.alternateNames.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Alternative Names")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func PrimaryMusclesWorkedSection() -> some View {
        if !entry.musclesWorkedPrimary.isEmpty {
            Section {
                Text(entry.musclesWorkedPrimary.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Primary Muscles Worked")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func SecondaryMusclesWorkedSection() -> some View {
        if !entry.musclesWorkedSecondary.isEmpty {
            Section {
                Text(entry.musclesWorkedSecondary.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Secondary Muscles Worked")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func BodyAreasTargetedSection() -> some View {
        if !entry.bodyAreasTargeted.isEmpty {
            Section {
                Text(entry.bodyAreasTargeted.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Body Areas Targeted")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func EquipmentSection() -> some View {
        if !entry.equipment.isEmpty {
            Section {
                Text(entry.equipment.joined(separator: ", "))
                    .workoutExerciseRow()
            } header: {
                Text("Equipment")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func PerformanceStepsSection() -> some View {
        Section {
            ForEach(entry.performanceSteps.indices, id: \.self) { stepIndex in
                let step = entry.performanceSteps[stepIndex]
                HStack {
                    VStack {
                        Image(systemName: "\(stepIndex + 1).circle")
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    HStack {
                        Text(step)
                        Spacer(minLength: 0)
                    }
                }
                .workoutExerciseRow()
            }
        } header: {
            Text("How to perform")
                .librarySectionHeader()
        }
    }
}

#Preview {
    let entry = try! ExerciseLibrary.fromBundle().exercises[0]
    
    NavigationStack {
        ExerciseEntryDetailView(entry: entry)
    }
}
