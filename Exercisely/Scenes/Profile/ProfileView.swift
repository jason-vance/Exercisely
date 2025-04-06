//
//  ProfileView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import SwiftUI

//TODO: Make setting for default rest (the rest value that's used on 'add a set')
struct ProfileView: View {
    
    @StateObject private var userSettings = UserSettings()
    
    private var birthdateBinding: Binding<Date> {
        .init {
            BirthDate(rawValue: userSettings.birthdateRawValue)?.date.toDate() ?? .now
        } set: { newValue in
            if let simpleDate = SimpleDate(date: newValue), let birthDate = BirthDate(date: simpleDate) {
                userSettings.birthdateRawValue = Int(birthDate.date.rawValue)
            } else {
                userSettings.birthdateRawValue = -1
            }
        }
    }
    
    private var birthdayText: String {
        BirthDate(rawValue: userSettings.birthdateRawValue)?.formatted() ?? "N/A"
    }
    
    var body: some View {
        List {
            PersonalSettingsSection()
            UnitsSettingsSection()
            ExerciseSettingsSection()
        }
        .listDefaultModifiers()
        .scrollDismissesKeyboard(.automatic)
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Profile")
                .navigationBarTitle()
        }
    }
    
    @ViewBuilder private func PersonalSettingsSection() -> some View {
        Section {
            UserSexRow()
            BirthDateRow()
        } header: {
            SectionHeader("Personal Settings")
        }
    }
    
    @ViewBuilder private func UserSexRow() -> some View {
        HStack {
            Text("Sex")
                .fieldLabel()
            Spacer()
            Menu {
                ForEach(UserSex.allCases, id: \.self) { sex in
                    Button(sex.rawValue) { userSettings.userSex = sex }
                }
            } label: {
                Text(userSettings.userSex.rawValue)
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func BirthDateRow() -> some View {
        HStack {
            Text("Birthdate")
                .fieldLabel()
            Spacer()
            Button {
                
            } label: {
                Text(birthdayText)
                    .fieldButton()
            }
            .overlay{
                DatePicker(
                    "",
                    selection: birthdateBinding,
                    displayedComponents: [.date]
                )
                .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func UnitsSettingsSection() -> some View {
        Section {
            WeightUnit()
            DistanceUnit()
            DurationUnit()
            RestUnit()
        } header: {
            SectionHeader("Default Unit Settings")
        }
    }
    
    @ViewBuilder private func WeightUnit() -> some View {
        HStack {
            Text("Weight")
                .fieldLabel()
            Spacer()
            Menu {
                Button(Weight.Unit.pounds.formatted()) {
                    userSettings.defaultWeightUnit = .pounds
                }
                Button(Weight.Unit.kilograms.formatted()) {
                    userSettings.defaultWeightUnit = .kilograms
                }
            } label: {
                Text(userSettings.defaultWeightUnit.formatted())
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DistanceUnit() -> some View {
        HStack {
            Text("Distance")
                .fieldLabel()
            Spacer()
            Menu {
                Button(Distance.Unit.feet.formatted()) {
                    userSettings.defaultDistanceUnit = .feet
                }
                Button(Distance.Unit.miles.formatted()) {
                    userSettings.defaultDistanceUnit = .miles
                }
                Button(Distance.Unit.meters.formatted()) {
                    userSettings.defaultDistanceUnit = .meters
                }
                Button(Distance.Unit.kilometers.formatted()) {
                    userSettings.defaultDistanceUnit = .kilometers
                }
            } label: {
                Text(userSettings.defaultDistanceUnit.formatted())
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DurationUnit() -> some View {
        HStack {
            Text("Duration")
                .fieldLabel()
            Spacer()
            Menu {
                Button(Workout.Exercise.Duration.Unit.seconds.formatted()) {
                    userSettings.defaultDurationUnit = .seconds
                }
                Button(Workout.Exercise.Duration.Unit.minutes.formatted()) {
                    userSettings.defaultDurationUnit = .minutes
                }
                Button(Workout.Exercise.Duration.Unit.hours.formatted()) {
                    userSettings.defaultDurationUnit = .hours
                }
            } label: {
                Text(userSettings.defaultDurationUnit.formatted())
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RestUnit() -> some View {
        HStack {
            Text("Rest")
                .fieldLabel()
            Spacer()
            Menu {
                Button(Workout.Exercise.Duration.Unit.seconds.formatted()) {
                    userSettings.defaultRestUnit = .seconds
                }
                Button(Workout.Exercise.Duration.Unit.minutes.formatted()) {
                    userSettings.defaultRestUnit = .minutes
                }
                Button(Workout.Exercise.Duration.Unit.hours.formatted()) {
                    userSettings.defaultRestUnit = .hours
                }
            } label: {
                Text(userSettings.defaultRestUnit.formatted())
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func ExerciseSettingsSection() -> some View {
        Section {
            WeightStepperValue()
            RepsStepperValue()
            DistanceStepperValue()
            DurationStepperValue()
            RestStepperValue()
        } header: {
            SectionHeader("Exercise Settings")
        }
    }
    
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @ViewBuilder private func WeightStepperValue() -> some View {
        NavigationLinkNoChevron {
            DoubleEditView(
                double: .init(
                    get: { userSettings.weightStepperValue },
                    set: { if let new = $0 { userSettings.weightStepperValue = new } }
                ),
                navigationBarTitle: "Weight Stepper Value"
            )
        } label: {
            HStack {
                Text("Weight Stepper Value")
                    .fieldLabel()
                Spacer()
                Text(userSettings.weightStepperValue.formatted())
                .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RepsStepperValue() -> some View {
        NavigationLinkNoChevron {
            IntEditView(
                int: .init(
                    get: { userSettings.repsStepperValue },
                    set: { if let new = $0 { userSettings.repsStepperValue = new } }
                ),
                navigationBarTitle: "Reps Stepper Value"
            )
        } label: {
            HStack {
                Text("Reps Stepper Value")
                    .fieldLabel()
                Spacer()
                Text(userSettings.repsStepperValue.formatted())
                .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DistanceStepperValue() -> some View {
        NavigationLinkNoChevron {
            DoubleEditView(
                double: .init(
                    get: { userSettings.distanceStepperValue },
                    set: { if let new = $0 { userSettings.distanceStepperValue = new } }
                ),
                navigationBarTitle: "Distance Stepper Value"
            )
        } label: {
            HStack {
                Text("Distance Stepper Value")
                    .fieldLabel()
                Spacer()
                Text(userSettings.distanceStepperValue.formatted())
                .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DurationStepperValue() -> some View {
        NavigationLinkNoChevron {
            DoubleEditView(
                double: .init(
                    get: { userSettings.durationStepperValue },
                    set: { if let new = $0 { userSettings.durationStepperValue = new } }
                ),
                navigationBarTitle: "Duration Stepper Value"
            )
        } label: {
            HStack {
                Text("Duration Stepper Value")
                    .fieldLabel()
                Spacer()
                Text(userSettings.durationStepperValue.formatted())
                .multilineTextAlignment(.trailing)
                .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RestStepperValue() -> some View {
        NavigationLinkNoChevron {
            DoubleEditView(
                double: .init(
                    get: { userSettings.restStepperValue },
                    set: { if let new = $0 { userSettings.restStepperValue = new } }
                ),
                navigationBarTitle: "Rest Stepper Value"
            )
        } label: {
            HStack {
                Text("Rest Stepper Value")
                    .fieldLabel()
                Spacer()
                Text(userSettings.restStepperValue.formatted())
                .multilineTextAlignment(.trailing)
                .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
