//
//  SignInScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

struct SignInScreen: View {
    @StateObject var signViewModel: SignInViweModel
    
    var body: some View {
        VStack{
            signViewModel.
        }.task {
            signViewModel.loginWithEmailAndPass(emailCredentials: <#T##EmailCredentials#>)
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen(signViewModel: <#T##SignInViweModel#>)
    }
}
