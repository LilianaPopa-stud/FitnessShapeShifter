//
//  MainScreen.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 05.03.2024.
//

import SwiftUI

struct MainScreenView: View {
    @State private var showSignInView: Bool = true
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
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
            
        }
        .fullScreenCover(isPresented: $showSignInView ) {
            NavigationStack{
                WelcomeScreenView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    MainScreenView()
}
