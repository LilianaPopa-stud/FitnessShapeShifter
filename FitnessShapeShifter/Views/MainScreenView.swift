//
//  MainScreen.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 05.03.2024.
//

import SwiftUI

struct MainScreenView: View {
    @State private var showSignInView: Bool = false
    var body: some View {
        ZStack{
            NavigationStack{
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
            
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                WelcomeScreenView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    MainScreenView()
}
