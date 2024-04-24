//
//  ForgotPasswordView.swift
//  ShapeShifterApp
//
//  Created by Liliana Popa on 07.03.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var success: Bool?
    var body: some View {
        NavigationView {
            ZStack{
                // background
                AppBackground()
                // foreground
                ScrollView {
                    VStack {
                        //
                        Image("logo")
                            .resizable()
                            .frame(maxWidth:80,maxHeight: 80, alignment:.center)
                            .padding(.vertical,30)
                        
                        Text("Forgot password?")
                            .font(Font.custom("Bodoni 72", size: 30))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom,5)
                        
                        Text("No worries, we'll send you a password reset link.")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom,20)
                        
                        CustomTextField(sfIcon: "at", hint: "Email Address", value: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.forgotPasswordResetLink()
                                    success = true
                                } catch {
                                    print("Error sending password reset email: \(error.localizedDescription)")
                                }
                            }
                            
                        }) {
                            Text("Send")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor2)
                                .cornerRadius(50)
                        }
                        .padding(.vertical,10)
                        
                        if success == true {
                            Text("Password reset link sent. Check your email.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                        }
                        if success == false {
                            Text("Invalid Email Address")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                Text("Back to")
                                    .font(.callout)
                                Text("sign in")
                                    .font(.callout)
                                    .fontWeight(.heavy)
                            }
                        }
                        Spacer()
                    }
                    .padding(30.0)
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView(viewModel: LoginViewModel())
}
