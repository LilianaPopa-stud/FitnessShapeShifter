//
//  Workout.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.
//

import SwiftUI

struct Workout: View {
    var body: some View {
        // title
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                           .fill(Color.white)
                           .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            VStack() {
                
                HStack {
                    Text("Workout title")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    //button
                    Button(action: {}, label: 
                            {Image(systemName: "ellipsis")
                            .font(.title2)} )
                  
                  
                }
                HStack{
                    Text(Date(), style: .date)
                        .foregroundStyle(.gray)
                    Text("at ").foregroundStyle(.gray) + Text(Date(), style: .time).foregroundStyle(.gray)
                    Spacer()
                }
               Divider()
                    .frame(height: 1)
                    .overlay(.accentColor2)
                VStack{
                    HStack {
                        Spacer()
                        VStack {
                            Text("Duration")
                                .font(.caption)
                            Text("10 min")
                                .font(.callout)
                                .fontWeight(.semibold)
                        
                        }
                        Spacer()
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        Spacer()

                        VStack {
                            Text("Calories")
                                .font(.caption)
                            Text("189 kcal")
                                .font(.callout)
                                .fontWeight(.semibold)
                        
                        }
                        Spacer()
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        Spacer()
                        
                        VStack {
                            Text("TVL")
                                .font(.caption)
                            Text("1900 kg")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .frame(height: 20)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                Divider()
                     .frame(height: 1)
                     .overlay(.accentColor2)
                .padding(.bottom,30)
                HStack {
                    VStack{
                        ZStack{
                        Image("Lats")
                               
                        Image("Lats")
                               
                        Image("Traps")
                              
                        Image("Deltoid")
                             
                        }
                    }
//                    Spacer()
                }
                
                Spacer()
                
            }
            .padding()
        }
        
     
    }
}

#Preview {
    Workout()
        .padding(20)
}
