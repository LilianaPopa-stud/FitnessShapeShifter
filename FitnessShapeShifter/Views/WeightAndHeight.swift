//
//  WeightAndHeight.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 08.02.2024.
//

import SwiftUI

struct WeightAndHeight: View {
    @State private var weight: Double?
    @State private var height: Double?
    @State private var selectedUnitIndex = 0
    @FocusState private var isHeightFieldFocused: Bool
    @FocusState private var isWeightFieldFocused: Bool
    @ScaledMetric(relativeTo: .body) var scaledPadding: CGFloat = 40
    @State private var selectedAgeIndex = 0
    @State private var isNextViewActive = false
    let ages = Array(18...99)
    let measurementUnits = ["cm/kg", "inch/lbs"]
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
                    
                    Text("Tell us your age, weight and height")
                        .font(Font.custom("Bodoni 72", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Your privacy is important to us, and this information will only be used to compute your BMI accurately")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                    HStack {
                        Text("Age:")
                        Picker("Age", selection: $selectedAgeIndex) {
                            ForEach(0..<ages.count) { index in
                                Text("\(ages[index])")
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        
                        Spacer()
                    }
                    // .padding(.leading, 20)
                    Picker(selection: $selectedUnitIndex, label: Text("")) {
                        ForEach(0..<2) {
                            Text(self.measurementUnits[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: .infinity)
                    HStack {
                        TextField("Height", value: $height, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isHeightFieldFocused)
                            .onTapGesture {
                                isHeightFieldFocused = true
                            }
                        TextField("Weight", value: $weight, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isWeightFieldFocused)
                            .onTapGesture {
                                isHeightFieldFocused = false
                                isWeightFieldFocused = true
                            }
                        
                        
                    }
                    
                    .padding(.bottom, 10)
                    NextButton(buttonTitle: "Next", isLast: false,
                               isActive: $isNextViewActive, destination: Goal())}
                .padding(30)
                
            }
            .scrollTargetBehavior(.paging)
            .padding(.bottom, keyboardHandler.keyboardIsShowing ? 20 : 0)
            
        }
    }
}

#Preview {
    WeightAndHeight()
}
