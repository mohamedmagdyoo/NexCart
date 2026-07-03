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
            HomeView()
                .navigationBarBackButtonHidden(true)
                .onAppear{
                    if let user = try? JSONDecoder().decode(UserEntity.self, from: userData!) {
                        print("👤 Logged in user:")
                        print("   id: \(user.id)")
                        print("   email: \(user.email)")
                        print("   displayName: \(user.displayName ?? "nil")")
                        print("   authProvider: \(user.authProvider)")
                        print("   isGuest: \(user.isGuest)")
                        print("   shopifyCustomerId: \(user.shopifyCustomerId ?? "not linked")")
                        print("   phone: \(user.phone ?? "nil")")
                        print("   acceptsMarketing: \(user.acceptsMarketing)")                    }
                }
        } else {
            NavigationStack {
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

