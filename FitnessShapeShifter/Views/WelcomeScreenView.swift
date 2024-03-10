//
//  Welcome Screen View
//  ShapeShifter
//
//  Created by Liliana Popa on 14.01.2024.
//

import SwiftUI

struct WelcomeScreenView: View {
    @Binding var showSignInView: Bool
    @State var isPresenting: Bool = false
    var body: some View {
        ZStack {
            // Background
            AppBackground()
            // Foregorund
            WelcomeScreenForeground(showSignInView: $showSignInView)
        }
        
    }
}

struct WelcomeScreenForeground: View {
    @Binding var showSignInView: Bool
    @State private var descriptionOpacity: Double = 0.0
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                // logo
                AppLogo()
                Text("Welcome to")
                    .font(Font.custom("Bodoni 72", size: 30))
                    .padding(.bottom, 5)
                // title
                AppTitle()
                    .padding(.bottom, 20)
                AppDescription()
                    .opacity(descriptionOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            descriptionOpacity=1.0
                        }
                    }
                Spacer()
                // Get started button
                LogInButton(showSignInView: $showSignInView)
                    .padding(.bottom)
                SignUp(showSignInView: $showSignInView)
                    .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SignUp: View {
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationLink(destination: RegisterView(showSignInView: $showSignInView)) {
            HStack(alignment: .center, spacing: 4) {
                Text("Don't have an account?")
                    .font(.callout)
                Text("Sign up")
                    .font(.callout)
                    .fontWeight(.heavy)
            }
        }
    }
}

struct AppDescription: View {
    var body: some View {
        Text("Elevate your fitness journey with ShapeShifter: track workouts, set goals, and celebrate your progress. Your pocket-sized coach for a healthier, stronger you!")
            .font(.caption)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 70)
            .foregroundColor(Color.textDescription)
    }
}
struct LogInButton: View {
@Binding var showSignInView: Bool
    let buttonTitle: String = "Log in"
    let backgroundColor: Color = Color.accentColor2
    let fontColor: Color = .white
    var body: some View {
        NavigationLink(destination: LoginView(showSignInView: $showSignInView)){
            Text(buttonTitle)
                .font(Font.custom("RobotoCondensed-Bold", size: 18))
                .foregroundColor(fontColor)
                .frame(width: 300, height: 55) //
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(backgroundColor)
                        .shadow(color: .shadow, radius: 4, x: 1, y: 3)
                )
        }
    }
}

struct AppLogo: View {
    var body: some View {
        Image("logo")
            .padding(.top, 80)
            .padding(.bottom, 40)
    }
}
struct AppTitle: View {
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Text("SHAPE")
                    .font(
                        Font.custom("Outfit", size: 40)
                            .weight(.bold)
                    )
                    .foregroundColor(Color.main)
                Text("Shifter")
                    .font(Font.custom("Oatmilk", size: 50))
                    .fontWeight(.black)
                    .foregroundColor(Color.accentColor2)
                    .rotationEffect(Angle(degrees: 2))
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
        }
    }
}

#Preview {
    WelcomeScreenView(showSignInView: .constant(false))
}
