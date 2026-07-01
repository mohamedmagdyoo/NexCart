//
//  NexCartApp.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct NexCartApp: App {
    // register app delegate for Firebase setup
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        FirebaseApp.configure()
//    }

    let persistenceController = PersistenceController.shared
    
    
    //Flag For Splash Screen
    @State private var showSplash: Bool = true
    //Flag For OnBoarding Flow
    @AppStorage("showOnBoarding") private var showOnBoarding = true

    var body: some Scene {
        WindowGroup {
            ZStack{

                //Splash Screen
                if showSplash{
                    LaunchScreen()
                }else if showOnBoarding{
                    //OnBoarding
                    OnboardingFlowView(onFinish:{
                        UserDefaults.standard.set(false, forKey: "showOnBoarding")
                    })
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }else{
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)                }
                
            }// ZStack
            .task {
                try! await Task.sleep(nanoseconds: 2000000000)
                showSplash = false
            }
        }
    }
}
