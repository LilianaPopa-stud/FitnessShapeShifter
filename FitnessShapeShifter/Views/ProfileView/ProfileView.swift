//
//  ProfileView.swift
//  FitnessShapeShifter
//  Created by Liliana Popa on 10.03.2024.

import SwiftUI
import Swift
import PhotosUI
import FirebaseStorage

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @State private var refreshProfile = false
    @State private var isShowingInfo = false
    
    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                
                VStack {
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .padding()
                    }
                        else {
                        VStack {
                            HStack {
                                Spacer()
                                CircularProfileImage(imageState: viewModel.imageState,size: CGSize(width: 100, height: 100))
                                Spacer()
                            }
                            
                            Text("\(viewModel.user?.displayName ?? "Guest")")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            
                            Text("\(String(describing: viewModel.user?.email ?? "guest@example.com"))")
                                .font(.subheadline)
                                .padding(.bottom, 5)
                            
                            Text("Joined on: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                                .font(.caption2)
                                .padding(.bottom, 10)
                            
                            
                        }
                        .shadow(radius: 10)
                        
                        VStack {
                            HStack(spacing: 10) {
                                StatView(title: "🎂", value: "\(viewModel.user?.age ?? 101) years")
                                
                                StatView(title: "⚖️", value: "\(viewModel.user?.weight ?? 0.0) kg")
                                StatView(title: "🧍‍♀️", value: "\(viewModel.user?.height ?? 0.0) cm")
                            }
                        }
                        .padding(.horizontal,25)
                        //.padding(.top,10)
                        
                        List {
                            Section(header: Text("Profile Information").bold()) {
                                InfoListItem(title: "Goal:", value: viewModel.user?.goal ?? "Maintain weight")
                                InfoListItem(title: "Activity Level:", value: viewModel.user?.activityLevel ?? "Sedentary")
                                InfoListItem(title: "BMI:", value: String(format: "%.2f", computeBMI()))
                                InfoListItem(title: "BMR:", value: String(format: "%.0f", computeBMR()))
                                InfoListItem(title: "Calories (based on activity level):", value: String(format: "%.0f", computeDailyCalorieNeedsBasedOnActivityLevel()))
                                InfoListItem(title: "Calories (based on goal):", value: String(format: "%.0f", computeDailyCalorieNeedsBasedOnGoal()))
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isShowingInfo.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .font(.title)
                                    }
                                    .padding(.bottom, 10)
                                    
                                    // Popover
                                    .popover(isPresented: $isShowingInfo, arrowEdge: .top) {
                                        InfoContent()
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    }
                                    Spacer()
                                }
                            }
                            
                        }
                        //.scrollContentBackground(.hidden)
                        .listStyle(.insetGrouped)
                        .accentColor(.blue) // Adjust accent color as desired
                    }
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(showSignInView: $showSignInView)
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.headline)
                                Text("Edit")
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear(){
            Task {
                try? await viewModel.loadCurrentUser()
                viewModel.downloadImage()
                viewModel.uiImage = nil
                viewModel.isLoading = false // delete later
                
            }
        }
        
    }
    
    
    /// functions
    func computeBMI() -> Double {
        guard let weight = viewModel.user?.weight,
              let height = viewModel.user?.height
        else {
            return 0.0
        }
        return weight / ((height/100) * (height/100))
    }
    
    func computeBMR() -> Double {
        guard let weight = viewModel.user?.weight,
              let height = viewModel.user?.height,
              let age = viewModel.user?.age,
              let gender = viewModel.user?.gender
        else {
            return 0.0
        }
        /* formula for BMR (Basal metabolic rate) Mifflin-St Jeor Equation:
         For men:
         BMR = 10W + 6.25H - 5A + 5
         For women:
         BMR = 10W + 6.25H - 5A - 161
         where: W is weight in kg, H is height in cm, A is age in years
         */
        if gender == "Female" {
            return (10 * weight + 6.25 * height - 5 * Double(age) - 161)
        } else {
            return (10 * weight + 6.25 * height - 5 * Double(age) + 5)
        }
    }
    func computeDailyCalorieNeedsBasedOnActivityLevel() -> Double {
        let bmr = computeBMR()
        guard let activityLevel = viewModel.user?.activityLevel
        else {
            return 0.0
        }
        switch activityLevel {
        case "Sedentary":
            return bmr * 1.2
        case "Lightly Active":
            return bmr * 1.375
        case "Moderately Active":
            return bmr * 1.55
        case "Very Active":
            return bmr * 1.725
        case "Extra Active":
            return bmr * 1.9
        default:
            return 0.0
        }
    }
    func computeDailyCalorieNeedsBasedOnGoal() -> Double {
        
        guard let goal = viewModel.user?.goal
        else {
            return 0.0
        }
        switch goal {
        case "Weight Loss":
            return computeDailyCalorieNeedsBasedOnActivityLevel() - 500
        case "Muscle Gain":
            return computeDailyCalorieNeedsBasedOnActivityLevel() + 250
        default:
            return computeDailyCalorieNeedsBasedOnActivityLevel()
        }
    }
    
}

struct StatView: View {
    var title: String
    var value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.accentColor2, lineWidth: 1)
                .shadow(color: .shadow, radius: 4, x: 1, y: 3)
                .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 75, alignment: .center)
            VStack(alignment: .center) {
                Text(title)
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accentColor2)
            }
            .padding(EdgeInsets(top: -5, leading: 2, bottom: -5, trailing: 2))
        }
    }
}
struct InfoContent: View {
    var body: some View {
        VStack {
            Text("Info")
                .font(.headline)
                .padding()
            Divider()
            Text("BMI (Body Mass Index): ").bold()
            + Text(" A measurement indicating whether your weight is appropriate for your height. ")
            + Text("If your BMI is less than 18.5, it falls within the underweight range. If your BMI is 18.5 to 24.9, it falls within the healthy weight range. If your BMI is 25.0 to 29.9, it falls within the overweight range.")
            Spacer()
            Text("BMR (Basal Metabolic Rate): ").bold() + Text("The number of calories your body needs at rest to perform vital functions like breathing and circulation, helping you understand your minimum calorie requirements for survival.")
            Spacer()
            Text("Daily calorie needs based on activity level: ").bold() +
            Text("The total number of calories your body needs in a day, factoring in your activity level to provide insight into how much energy you require to maintain weight while staying healthy and active.")
            Spacer()
            Text("Daily calorie needs based on goal: ").bold() +
            Text("The total number of calories your body needs in a day, adjusted according to your specific fitness goal to support weight loss, muscle gain, or overall health and activity level. ")
            Spacer()
            
        }
    }
}
struct InfoListItem: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
            Text(value)
        }
    }
}
#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
            .environmentObject(ProfileViewModel())
        
    }
}
