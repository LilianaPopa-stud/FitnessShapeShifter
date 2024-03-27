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
    @State var selectedTab = 0
    init() {
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .accentColor1
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    var body: some View {
      
       
        TabView(selection: $selectedTab){
                   
                    ProfileView(showSignInView: $showSignInView)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(0)
                        .id(profileViewRefreshFlag)
                    Explore()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Explore")
                        }
                        .tag(1)
                    WorkoutsView()
                        .tabItem {
                            Image(systemName: "dumbbell")
                            Text("Workouts")
                        }
                        .tag(2)
                    Stats()
                        .tabItem {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Stats")
                        }
                        .tag(3)
                }
        
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
}
