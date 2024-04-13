import SwiftUI

struct SetEditView: View {
    
    @Binding var isSetEditingPresented: Bool
    @State private var reps: String = "0"
    @State private var weight: String = "0"
    @State private var isRepsFieldFocused: Bool = false
    @State private var isWeightFieldFocused: Bool = false
    @State private var saveSet: Bool = false
    @Binding  var exerciseSet: ExerciseSet
    @Binding var exerciseIndex: Int
    @Binding var setIndex: Int
    @Binding var tuples: [Exercise]
    
    var body: some View {
        ZStack {
          //  Color.primary.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Edit Set")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom,-10)
                    .padding(.top,20)
                VStack{
                    HStack {
                        HStack {
                            Text("\(reps) reps")
                                .frame(width: 160, height: 70)
                                .border(isRepsFieldFocused ?  Color.blue : Color.gray, width: 3)
                                .foregroundColor(.white)
                                .font(.title2)
                                .disabled(true)
                                //.background(.black)
                                .onTapGesture {
                                    isRepsFieldFocused = true
                                    isWeightFieldFocused = false
                                }
                            
                            
                            Text("\(weight) kg")
                                .frame(width: 160, height: 70)
                                .border(isWeightFieldFocused ?  Color.blue : Color.gray, width: 3)
                                .foregroundColor(.white)
                                .font(.title2)
                                .keyboardType(.numberPad)
                               // .background(.black)
                                .disabled(true)
                                .onTapGesture {
                                    isRepsFieldFocused = false
                                    isWeightFieldFocused = true
                                }
                            
                            // + and - buttons
                            
                        }
                        .padding(.horizontal,20)
                    }
                    if isRepsFieldFocused {
                        KeyPad(string: $reps, isRepsFieldFocused: $isRepsFieldFocused, saveSet: $saveSet)
                            .frame(width: 300 ,height: 200)
                    } else {
                        KeyPad(string: $weight, isRepsFieldFocused: $isRepsFieldFocused, saveSet: $saveSet)
                            .frame(width:300,height: 200)
                    }
                }
            }
        }
        .onAppear(){
            isRepsFieldFocused = true
            isWeightFieldFocused = false
        }
        .onChange(of: saveSet) {
            if saveSet {
               saveSetFunc()
            }
        }
        
    }
}
struct KeyPadRow: View {
    var keys: [String]
    
    var body: some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}

struct KeyPad: View {
    
    @Binding var string: String
    @Binding var isRepsFieldFocused: Bool
    @Binding var saveSet: Bool
    
    var body: some View {
        VStack {
            KeyPadRow(keys: ["1", "2", "3"])
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: [ "0", "+","-"])
            KeyPadRow(keys: [".","Save","⌫"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }
    
    private func keyWasPressed(_ key: String) {
        switch key {
        case "." where string.contains("."): break
        case "." where isRepsFieldFocused == true: break
        case "." where string == "0": string += "."
        case "0" where string == "0": return
        case "⌫":
            string.removeLast()
            if string.isEmpty { string = "0" }
            // plus case
        case "+" where isRepsFieldFocused==false: string = String((Double(string) ?? 0.0)+0.5)
        case "+" where isRepsFieldFocused==true: string = String((Int(string) ?? 1)+1)
            // minus case for reps
        case "-" where isRepsFieldFocused==true && Int(string) ?? 0==0 : string = "0"
        case "-" where isRepsFieldFocused==true && Int(string) ?? 0>0 : string = String((Int(string) ?? 0)-1)
            // minus case for weight
        case "-" where Double(string) ?? 0>0: string = String((Double(string) ?? 0.0)-0.5)
        case "-" where Int(string) ?? 0==0: string = "0"
            
            // save
        case "Save": saveSet = true
            // default case (numbers
        default: if string == "0" && key != "0" {
            string = key }
            else {
            string += key
            }
        }
    }
}

extension SetEditView{
    func saveSetFunc() {
        isSetEditingPresented = false
        tuples[exerciseIndex].sets[setIndex].reps = Int(reps) ?? 0
        tuples[exerciseIndex].sets[setIndex].weight = Double(weight) ?? 0.0
    }
}

//struct SetEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetEditView(isSetEditingPresented: .constant(true), exerciseSet: .constant(ExerciseSet(reps: 10, weight: 20)))
//            .previewLayout(.sizeThatFits)
//    }
//}

