//
//  WeightAndHeight.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 08.02.2024.
//

import SwiftUI

struct WeightAndHeight: View {
    
    @StateObject var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    @State private var birthDate = Date.now
    @State private var weight: Double?
    @State private var height: Double?
   
    @FocusState private var isHeightFieldFocused: Bool
    @FocusState private var isWeightFieldFocused: Bool
    @ScaledMetric(relativeTo: .body) var scaledPadding: CGFloat = 40
    @State private var selectedAgeIndex = 0
    @State private var isNextViewActive = false
    let age = Array(18...99)

    @ObservedObject private var keyboardHandler = KeyboardHandler()
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack {
                    Text("Let's set up your profile")
                        .font(Font.custom("Bodoni 72", size: 30, relativeTo: .headline))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                    Image(.deadlift)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 250, maxHeight: 250, alignment: .center)
                    
                    Text("Tell us your age, height and weight")
                        .font(Font.custom("Bodoni 72", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Your privacy is important to us, and this information will only be used to compute your BMI accurately")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                        Spacer()
                    HStack {
                        Text("Age:")
                    
                        Picker("Age", selection: $selectedAgeIndex) {
                            ForEach(0..<age.count) { index in
                                Text("\(age[index])")
                            }
                        }
                        .onChange(of: selectedAgeIndex, { viewModel.age = age[selectedAgeIndex] })
                        .pickerStyle(DefaultPickerStyle())
                    }
                    
                    HStack {
                        TextField("Height (cm)", value: $viewModel.height, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isHeightFieldFocused)
                            .onTapGesture {
                                isHeightFieldFocused = true
                            }
                            .onChange(of: viewModel.height) {
                            
                                viewModel.age = age[selectedAgeIndex]
                            }
                            .onSubmit {
                                isHeightFieldFocused = false
                                isWeightFieldFocused = true
                            }
                        TextField("Weight (kg)", value: $viewModel.weight, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isWeightFieldFocused)
                            .onSubmit {
                                isWeightFieldFocused = false
                                
                            }
                            .onChange(of: viewModel.weight) {
                                viewModel.age = age[selectedAgeIndex]
                            }
                        
                    }
                    .padding(.bottom, 40)
                    NextButton(buttonTitle: "Next", isLast: false,
                               isActive: $isNextViewActive, destination: Goal(viewModel: viewModel, showSignInView: $showSignInView, showOnboarding: $showOnboarding))}
                
                .padding(30)
                
            }
            .scrollTargetBehavior(.paging)
            .padding(.bottom, keyboardHandler.keyboardIsShowing ? 20 : 0)
            
        }
    }
}

#Preview {
    WeightAndHeight(viewModel: ProfileViewModel(), showSignInView: .constant(true),showOnboarding: .constant(false))
}
