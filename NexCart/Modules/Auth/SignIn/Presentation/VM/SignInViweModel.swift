//
//  SignInViweModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

private enum SignInScreenState{
    case idel
    case loading
    case success
}

struct Alert: Identifiable{
    var id: UUID = UUID()
    var title: String
    var description: String
}

class SignInViweModel: ObservableObject{
    @Published private var screenState: SignInScreenState = .idel
    @Published private var alert: Alert?
    
    //UseCases
    private var loginWithEmailPassUC: LoginWithEmailUseCaseProtocol
    private var loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol
    private var loginAsGuestUC: LoginAsGuestUseCaseProtocol
    
    init(loginWithEmailPassUC: LoginWithEmailUseCaseProtocol, loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol, loginAsGuestUC: LoginAsGuestUseCaseProtocol) {
        self.loginWithEmailPassUC = loginWithEmailPassUC
        self.loginWithProviderUC = loginWithProviderUC
        self.loginAsGuestUC = loginAsGuestUC
    }
    
    func loginWithEmailAndPass(emailCredentials: EmailCredentials){
        screenState = .loading
        Task{
            do{
                var userEntity =  try await loginWithEmailPassUC.execute(credentials: emailCredentials)
                
                //Save the userEntity so we can use it any where
                let userData = try JSONEncoder().encode(userEntity)
                UserDefaults.standard.set(userData, forKey: "userEntity")
                screenState = .success
            }catch let error as AuthError{
                //Have to make one shard function to handle the errros just retrun discription
                print(error.errorDescription)
                alert = Alert(title: "Error Happend", description: error.errorDescription)
                screenState = .idel
            }
        }
    }
    
    //Continue all the useCases here so i can use those function in the view
}

//Implment the shared func that handle the all the types of AuthE
