//
//  FitnessShapeShifterApp.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Configured Firebase!")
    return true
  }
}


@main
struct FitnessShapeShifterApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
           //WelcomeScreenView()
            //RegisterView()
            //WeightAndHeight()
           // MainScreenView()
            //ExercisesExploreAndSearchView()
            AddWorkoutView()
        }
    }
}


