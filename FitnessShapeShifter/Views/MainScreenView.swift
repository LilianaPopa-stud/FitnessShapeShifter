//
//  MainScreen.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 05.03.2024.
//

import SwiftUI

struct MainScreenView: View {
    @State private var profileViewRefreshFlag = UUID()
    @State private var showSignInView: Bool = false
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    @StateObject var workoutViewModel: WorkoutViewModel = WorkoutViewModel()
    @State var selectedTab = 0
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .accentColor1
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    var body: some View {
      
       
        TabView(selection: $selectedTab){
            Group{
                ProfileView(showSignInView: $showSignInView)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(0)
                    .id(profileViewRefreshFlag)
                ExercisesExploreAndSearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }
                    .tag(1)
                Workouts()
                    .tabItem {
                        Image(systemName: "dumbbell")
                        Text("Workouts")
                    }
                    .environmentObject(workoutViewModel)
                    .tag(2)
                
                Stats()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Stats")
                    }
                    .tag(3)
            } .toolbarBackground(.white, for: .tabBar)
              .toolbarBackground(.visible, for: .tabBar)
                
                }
        .environmentObject(profileViewModel)
        
        .onAppear {
            if (try? AuthenticationManager.shared.getAuthenticatedUser()) != nil {
                showSignInView = false
            } else {
                showSignInView = true
            }

                                  
        }
        .fullScreenCover(isPresented: $showSignInView ) {
            NavigationStack{
                WelcomeScreenView(showSignInView: $showSignInView)
            }
        }
        .onChange(of: showSignInView) {
            profileViewRefreshFlag = UUID()
        }
    }
    
}

#Preview {
    MainScreenView()
        .environmentObject(ProfileViewModel())
        .environmentObject(WorkoutViewModel())
}
