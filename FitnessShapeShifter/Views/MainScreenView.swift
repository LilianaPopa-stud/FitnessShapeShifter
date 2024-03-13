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
    init() {
   
           UISegmentedControl.appearance().selectedSegmentTintColor = .accentColor1
           let attributes: [NSAttributedString.Key:Any] = [
               .foregroundColor: UIColor.white]
           UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
       }
    var body: some View {
        ZStack{
            NavigationStack{
                ProfileView(showSignInView: $showSignInView)
                    .id(profileViewRefreshFlag)
            }
        }
        .onAppear {
            
            
                if let authUser = try? AuthenticationManager.shared.getAuthenticatedUser() {
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
