//
//  ProfileView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import SwiftUI

//TODO: Make the exercise settings fields look better (blue lines are too long)
//TODO: Make setting for default rest value
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
                .bold(true)
                .foregroundStyle(Color.text)
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
        HStack {
            Text("Weight Stepper Value")
                .fieldLabel()
            Spacer()
            TextField(
                "Weight Stepper Value",
                value: $userSettings.weightStepperValue,
                formatter: decimalFormatter
            )
            .multilineTextAlignment(.trailing)
            .fieldButton()
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
        HStack {
            Text("Distance Stepper Value")
                .fieldLabel()
            Spacer()
            TextField(
                "Distance Stepper Value",
                value: $userSettings.distanceStepperValue,
                formatter: decimalFormatter
            )
            .multilineTextAlignment(.trailing)
            .fieldButton()
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DurationStepperValue() -> some View {
        HStack {
            Text("Duration Stepper Value")
                .fieldLabel()
            Spacer()
            TextField(
                "Duration Stepper Value",
                value: $userSettings.durationStepperValue,
                formatter: decimalFormatter
            )
            .multilineTextAlignment(.trailing)
            .fieldButton()
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RestStepperValue() -> some View {
        HStack {
            Text("Rest Stepper Value")
                .fieldLabel()
            Spacer()
            TextField(
                "Rest Stepper Value",
                value: $userSettings.restStepperValue,
                formatter: decimalFormatter
            )
            .multilineTextAlignment(.trailing)
            .fieldButton()
        }
        .workoutExerciseRow()
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
