//
//  ProfileView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/30/25.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("UserSex") var userSex: UserSex = .unknown
    @AppStorage("birthdateRawValue") var birthdateRawValue: Int = -1
    
    private var birthdateBinding: Binding<Date> {
        .init {
            BirthDate(rawValue: birthdateRawValue)?.date.toDate() ?? .now
        } set: { newValue in
            if let simpleDate = SimpleDate(date: newValue), let birthDate = BirthDate(date: simpleDate) {
                birthdateRawValue = Int(birthDate.date.rawValue)
            } else {
                birthdateRawValue = -1
            }
        }

    }
    
    private var birthdayText: String {
        BirthDate(rawValue: birthdateRawValue)?.formatted() ?? "N/A"
    }

    var body: some View {
        List {
            PersonalSettingsSection()
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
                    Button(sex.rawValue) { userSex = sex }
                }
            } label: {
                Text(userSex.rawValue)
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
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
