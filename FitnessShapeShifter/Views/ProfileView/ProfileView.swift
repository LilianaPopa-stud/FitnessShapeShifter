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
    @State private var isShowingInfo = false
    
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
                      
                        
                        Text("\(String(describing: viewModel.user?.email ?? "guest@example.com"))")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                        
                        
                        
                        Text("Joined on: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                            .font(.caption2)
                            .padding(.bottom, 10)
                          //  .padding(.bottom,20)
                        
                    }
//                    .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor1.opacity(0.4), Color.accentColor2.opacity(0.7)]), startPoint: .top, endPoint: .bottomLeading))
                    
                    .shadow(radius: 10)
                    //.padding(.bottom,20)
                    
                    Button(action: {
                        isShowingInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title)
                    }
                    .padding(.bottom, 10)
                    
                    // Popover
                    .popover(isPresented: $isShowingInfo, arrowEdge: .top) {
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
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
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
                            StatView(title: "Goal", value: "\(viewModel.user?.goal ?? "Maintain weight")")
                            StatView(title: "Activity Level",value: "\(viewModel.user?.activityLevel ?? "Sedentary")")
                        }
                        HStack(spacing: 10) {
                            StatView(title: "BMI", value: String(format: "%.2f", computeBMI()))
                            StatView(title: "BMR", value: String(format: "%.0f", computeBMR()))
                        }
                        HStack(spacing: 10) {
                            StatView(title: "Daily calorie needs based on activity level", value: String(format: "%.0f", computeDailyCalorieNeedsBasedOnActivityLevel()))
                        }
                        HStack(spacing: 10) {
                            StatView(title: "Daily calorie needs based on your goal", value: String(format: "%.0f", computeDailyCalorieNeedsBasedOnGoal()))
                        }
                        
                    }
                    .padding(.horizontal,25)
                    Spacer()
                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        NavigationLink {
//                            SettingsView(showSignInView: $showSignInView)
//                        } label: {
//                            Image(systemName: "gearshape")
//                                .font(.headline)
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
//                            HStack {
//                                Image(systemName: "pencil")
//                                    .font(.headline)
//                                Text("Edit")
//                            }
//                        }
//                    }
//                }
            }
            
        }
        .onAppear(){
            Task {
                try? await viewModel.loadCurrentUser()
                viewModel.downloadImage()
                viewModel.uiImage = nil
            }
        }
        //.navigationBarTitleDisplayMode(.inline)
//        .navigationTitle("Profile")
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
        let bmr = computeBMR()
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
                .foregroundColor(.accentColor2)
                .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 75, alignment: .center)
                .shadow(color: .black, radius: 2, x: 0.5, y: 0.5)
            
            
            VStack(alignment: .center) {
                Text(title)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
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
