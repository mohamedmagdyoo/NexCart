//
//  LaunchScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Image("app_logo")
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}
struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
