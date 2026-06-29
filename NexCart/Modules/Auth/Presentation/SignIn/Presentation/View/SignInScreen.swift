//
//  SignInScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

// MARK: - Root Screen
struct SignInScreen: View {
    @StateObject private var viewModel: SignInViewModel = DIContainer.shared.container.resolve(SignInViewModel.self)!
    
    var body: some View {
        ZStack {
            Color.authBackground.ignoresSafeArea()
            
            switch viewModel.screenState {
            case .idle:
                SignInIdleState(viewModel: viewModel)
            case .loading:
                SignInLoadingState()
            case .success:
                SignInSuccessState(vm: viewModel)
            }
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.description ),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - Idle State
struct SignInIdleState: View {
    @ObservedObject var viewModel: SignInViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var navToSignUp: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: Title
            Text("Welcome\nback.")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.authTitle)
                .lineSpacing(2)
            
            Text("Sign in to continue your wardrobe.")
                .font(.subheadline)
                .foregroundColor(.authSubtitle)
                .padding(.top, 8)
                .padding(.bottom, 36)
            
            // MARK: Fields
            ObsidianField(label: "EMAIL", placeholder: "hello@maison.co", text: $email)
                .keyboardType(.emailAddress)
            
            ObsidianField(label: "PASSWORD", placeholder: "••••••••", text: $password, isSecure: true)
                .padding(.top, 16)
            
            // MARK: Forgot Password
            Button("Forgot password?") {
                // navigate to ForgotPassScreen
            }
            .font(.footnote)
            .foregroundColor(.authForgotPass)
            .padding(.top, 10)
            .padding(.bottom, 28)
            
            // MARK: Sign In Button
            Button {
                viewModel.loginWithEmailAndPass(
                    credentials: EmailCredentials(email: email, password: password)
                )
            } label: {
                Text("Sign in")
            }
            .buttonStyle(AuthPrimaryButtonStyle())
            
            // MARK: Social Divider
            AuthDivider(text: "OR CONTINUE WITH")
                .padding(.vertical, 24)
            
            VStack(spacing: 5){
                
                // MARK: Social Buttons
                SignInWithAppleButton(.signIn) { request in
                    
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        viewModel.loginWithSocialProvider(provider: .apple(authorization: authorization))
                    case .failure(let error):
                        print("Apple Sign In failed: \(error)")
                    }
                }
                .frame(maxHeight: 40)
                .buttonStyle(AuthPrimaryButtonStyle())
                
                Button {
                    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let vc = scene.windows.first?.rootViewController else { return }
                    viewModel.loginWithSocialProvider(provider: .google(vc: vc))                        } label: {
                        HStack{
                            Image("icon_google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Google")
                        }
                    }
                    .buttonStyle(AuthSocialButtonStyle())
                
                // MARK: Footer
                AuthFooterLink(
                    message: "New here?",
                    linkText: "Create an account"
                ) {
                    print("Nav To SignUpScreen")
                    // flip the flage
                    navToSignUp = true
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)
                
                
                
                HStack{
                    Image(systemName: "person.fill")
                    Text("Try with guest mode")
                        .font(.system(size: 16,weight: .medium,design: .serif))
                        .opacity(0.5)
                }
                .onTapGesture {
                    viewModel.loginAsGuest()                }
            }
            .navigationDestination(isPresented: $navToSignUp){
                SignUpScreen()
            }
            .padding(.horizontal, 24)
            }//VStack
        .padding()
    }
}



// MARK: - Loading State
struct SignInLoadingState: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.authTitle)
            Text("Signing in...")
                .font(.footnote)
                .foregroundColor(.authSubtitle)
        }
    }
}

// MARK: - Success State
struct SignInSuccessState: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State var navToHomeScreen: Bool = false
    @ObservedObject var vm: SignInViewModel
    
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.authTitle)
                .scaleEffect(scale)
                .opacity(opacity)
            
            Text("Welcome back.")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.authTitle)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .task {
            do{
                try await Task.sleep(nanoseconds: 2000000000)
                print("Nav to home screen")
                vm.saveUser()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Preview
struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInIdleState(viewModel: SignInViewModel(
            loginWithEmailPassUC: MockLoginWithEmailUseCase(),
            loginWithProviderUC: MockLoginWithSocialProviderUseCase(),
            loginAsGuestUC: MockLoginAsGuestUseCase()
        ))
    }
}
