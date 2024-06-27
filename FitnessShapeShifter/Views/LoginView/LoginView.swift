////
////  LoginView.swift
////  ShapeShifter
////
////  Created by Liliana Popa on 05.02.2024.
////
//
import SwiftUI
import Foundation
import Combine


struct LoginView: View {
    @Binding var showSignInView: Bool
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible: Bool = false
    @State var success: Bool?
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    let buttonTitle = "Sign in"
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
                            
                        //
                        Text("Welcome back!")
                            .font(Font.custom("Bodoni 72", size: 40))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom)
                        
                        Text("Please sign in to continue")
                            .font(.subheadline)
                            .padding()
                            .foregroundStyle(.secondary)
                        
                        
                        CustomTextField(sfIcon: "person", hint: "Email", value: $viewModel.email)
                            .focused($isEmailFocused)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onTapGesture {
                                isEmailFocused = true
                            }
                            .onSubmit {
                                isEmailFocused = false
                                isPasswordFocused = true
                            }
                        
                        
                        CustomTextField(sfIcon: "lock", hint: "Password", value: $viewModel.password,isPasswordField: true) // set to true later
                            .focused($isPasswordFocused)
                            .keyboardType(.default)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onSubmit {
                                isPasswordFocused = false
                            }
                        
                        // forgot password? button
                        ForgotPasswordButton(viewModel: viewModel)
                        // log in
                        LogInConfirmationButton(showSignInView: $showSignInView, viewModel: viewModel, success: $success)
                            .padding(.top, 20)
                        //disabling until the data is entered
                            .disableWithOpacity(viewModel.email.isEmpty || viewModel.password.isEmpty)
                        if success == false {
                            Text("Invalid email or password")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .padding(30.0)
                }
                
                .scrollTargetBehavior(.paging)
                .safeAreaPadding(.horizontal, 10)
                
                VStack{
                    Spacer()
                    SignUp(showSignInView: $showSignInView)
                        .opacity(isKeyboardVisible ? 0 : 1)
                        .padding(.bottom, 20)
                    
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height
                        self.isKeyboardVisible = true
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    self.isKeyboardVisible = false
                }
            }
        }
        
    }
    
}




#Preview {
    LoginView(showSignInView: .constant(false))
}
