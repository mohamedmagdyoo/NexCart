//
//
//
//
//  ContentView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("userEntity") private var userData: Data?
 
    var body: some View {
        
            if userData != nil {
                NavigationStack{
                    HomeScreen()
                }
            } else {
                NavigationStack{
                    SignInScreen()
                }
                .navigationBarBackButtonHidden(true)
            }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct HomeScreen: View{
    var body: some View{
        VStack{
            Text("NexCart")
                .font(.system(size: 22,weight: .heavy, design: .rounded))
            
            Button{
                UserDefaults.standard.removeObject(forKey: "userEntity")
            }label: {
                Text("RemoveUserEntity")
            }
        }
    }
}
