//
//  ProfileView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//
// put the following code in a new file named ProfileViewModel.swift
import SwiftUI
import Swift
import PhotosUI
import FirebaseStorage


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var refreshProfile = false
    @State private var bmi = 0.0
    @State private var bmr = 0.0
    @State private var dailyCalorieNeeds = 0.0
    
    
    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            CircularProfileImage(imageState: viewModel.imageState)
                            Spacer()
                        }
                        
                        Text("\(viewModel.user?.displayName ?? "Guest")")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("\(String(describing: viewModel.user?.email ?? "guest@example.com"))")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                            .foregroundStyle(.white)
                        
                        
                        Text("Joined on: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                            .font(.caption2)
                            .padding(.bottom, 5)
                            .foregroundStyle(.white)
                            .padding(.bottom,20)
                        
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color.peachy.opacity(0.5), Color.accentColor2.opacity(0.9)]), startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 10)
                    .padding(.bottom,30)
                    
                    
                    
                    ScrollView {
                        HStack(spacing: 10) {
                            StatView(title: "Gender", value: "\(viewModel.user?.gender ?? "Unknown")")
                            StatView(title: "Age", value: "\(viewModel.user?.age ?? 101)")
                        }
                        HStack(spacing: 10) {
                            StatView(title: "Weight", value: "\(viewModel.user?.weight ?? 0.0)")
                            StatView(title: "Height", value: "\(viewModel.user?.height ?? 0.0)")
                        }
                        HStack(spacing: 10) {
                            StatView(title: "BMI", value: String(format: "%.2f", bmi))
                            StatView(title: "BMR", value: String(format: "%.0f", bmr))
                        }
                        HStack(spacing: 10) {
                            StatView(title: "Goal", value: "\(viewModel.user?.goal ?? "Maintain weight")")
                            StatView(title: "Activity Level",value: "\(viewModel.user?.activityLevel ?? "Sedentary")")
                        }
                        HStack(spacing: 10) {
                            StatView(title: "Daily calorie needs based on activity level", value: String(format: "%.0f",dailyCalorieNeeds))
                        }
                        
                    }
                    .padding(.horizontal,25)
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
            }
            if viewModel.user != nil {
                bmi = computeBMI()
                bmr = computeBMR()
                dailyCalorieNeeds = computeDailyCalorieNeedsBasedOnActivityLevel()
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
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
}

struct StatView: View {
    var title: String
    var value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.accentColor2)
                .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 75, alignment: .center)
                .shadow(color: .black, radius: 2, x: 0.5, y: 0.5)
            
            
            VStack(alignment: .center) {
                Text(title)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: -5, leading: 2, bottom: -5, trailing: 2))
            
        }
    }
}


#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
        
    }
}
