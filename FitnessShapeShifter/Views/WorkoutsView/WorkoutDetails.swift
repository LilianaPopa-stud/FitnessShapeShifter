//
//  WorkoutDetailsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 19.04.2024.
//

import SwiftUI

struct WorkoutDetails: View {
    @Binding var isActive: Bool
    var workout: DBWorkout
    var body: some View {
        NavigationStack {
            VStack {
           
            }
            .navigationTitle("Workout Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isActive = false
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "arrow.backward")
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20))
                                .padding(.leading,10)
                        }
                       
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isActive = false
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                )
                                .padding(.leading,10)
                           
                                
                        }
                       
                    }
                }
            }
        }
        
        
      
    }
}

#Preview {
    WorkoutDetails(isActive: .constant(true), workout: DBWorkout())
      
}
