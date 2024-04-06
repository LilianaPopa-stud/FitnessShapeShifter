//
//  AddWorkoutButton.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.
//

import SwiftUI

struct AddWorkoutButton: View {
    @StateObject var viewModel = ExerciseViewModel()
    var body: some View {
        Button(action: {
            Task{
                
            }
        }
               ,label: {
            VStack {
                HStack {
                    Text("Add Workout")
                    Image(systemName: "plus.circle")
                }
            }
            .font(.headline)
            .font(Font.custom("RobotoCondensed-Bold", size: 18))
            .foregroundColor(.accentColor2)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(.accentColor2, lineWidth: 1)
                    .shadow(color: .shadow, radius: 4, x: 1, y: 3))
        })
    }
}

#Preview {
    AddWorkoutButton()
}
