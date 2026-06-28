//
//  NexCartApp.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

@main
struct NexCartApp: App {
    let persistenceController = PersistenceController.shared
    
    //Flag For Splash Screen
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack{
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                //Splash Screen
                if showSplash{
                    LaunchScreen()
                }
            }// ZStack
            .task {
                try! await Task.sleep(nanoseconds: 2000000000)
                showSplash = false
            }
        }
    }
}
