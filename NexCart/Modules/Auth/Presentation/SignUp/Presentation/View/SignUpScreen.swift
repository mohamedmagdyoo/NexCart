//
//  SignUpScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignUpScreen: View {
    @StateObject private var viewModel: SignUpViewModel = DIContainer.shared.container.resolve(SignUpViewModel.self)!

    var body: some View {
        ZStack {
            Color.authBackground.ignoresSafeArea()

            switch viewModel.screenState {
            case .idle:
                SignUpIdleState(viewModel: viewModel)
            case .loading:
                SignUpLoadingState()
            case .success:
                SignUpSuccessState(vm: viewModel)
            case .error(let error):
                Text("\(error)")
            }
        }
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToHome) {
            HomeView()
                .interactiveDismissDisabled(true)
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("OK")))
        }
    }
}
// MARK: - Idle State
struct SignUpIdleState: View {
    @ObservedObject var viewModel: SignUpViewModel

//    @State private var firstName: String = ""
//    @State private var lastName: String = ""
//    @State private var phone: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var passwordConfirmation: String = ""
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Back Button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.authTitle)
                        .font(.system(size: 18, weight: .medium))
                }
                .padding(.top, 16)
                .padding(.bottom, 32)

                // MARK: Title
                Text("Make it\nyours.")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.authTitle)
                    .lineSpacing(2)

                Text("A few details and your wardrobe is ready.")
                    .font(.subheadline)
                    .foregroundColor(.authSubtitle)
                    .padding(.top, 8)
                    .padding(.bottom, 36)

                // MARK: Fields
                VStack{
                    ObsidianField(label: "FIRST NAME", placeholder: "Eliza", text: $viewModel.firstName)
                    ObsidianField(label: "Last NAME", placeholder: "Hart", text: $viewModel.lastName)

                    ObsidianField(label: "EMAIL", placeholder: "hello@maison.co", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .padding(.top, 16)
                    ObsidianField(label: "Phone", placeholder: "+201094858338", text: $viewModel.phone)
                        .keyboardType(.numberPad)
                        .padding(.top, 16)

                    ObsidianField(label: "PASSWORD", placeholder: "At least 8 characters", text: $viewModel.password, isSecure: true)
                        .padding(.top, 16)
                        .padding(.bottom, 28)
                    ObsidianField(label: "passwordConfirmation", placeholder: "At least 8 characters", text: $viewModel.passwordConfirmation, isSecure: true)
                        .padding(.top, 16)
                        .padding(.bottom, 28)
                }

                // MARK: Create Account Button
                Button {
                    viewModel.createNewAccount(
                        credentials: viewModel.credentials()
                    )
                } label: {
                    Text("Create account")
                }
                .buttonStyle(AuthPrimaryButtonStyle())

                // MARK: Social Divider
                AuthDivider(text: "OR CONTINUE WITH")
                    .padding(.vertical, 24)

                VStack{
                    // MARK: Social Buttons
                    HStack(spacing: 12) {
                        

                        
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
                        .frame(height: 50)

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
                    }

                    Spacer(minLength: 30)
                    
                    // MARK: Footer
                    AuthFooterLink(
                        message: "Already have one?",
                        linkText: "Sign in"
                    ) {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 24)
                }
               
    }
}

// MARK: - Loading State
struct SignUpLoadingState: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.authTitle)
            Text("Creating your account...")
                .font(.footnote)
                .foregroundColor(.authSubtitle)
        }
    }
}

// MARK: - Success State
struct SignUpSuccessState: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    @ObservedObject var vm: SignUpViewModel

    @State private var didTriggerNavigation: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.authTitle)
                .scaleEffect(scale)
                .opacity(opacity)

            Text("Welcome to NexCart.")
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
           
            guard !didTriggerNavigation else { return }

            do{
                try await Task.sleep(nanoseconds: 2000000000)
                guard !Task.isCancelled else { return }
                didTriggerNavigation = true
                vm.saveUserEntity()
            }catch{
                vm.screenState = .error(error: error.localizedDescription)
            }
            
        }
    }
}

// MARK: - Preview
struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpIdleState(viewModel: SignUpViewModel(
            signUpUseCase: MockCreateNewAccountUseCase(),
            loginWithProviderUC: MockLoginWithSocialProviderUseCase()
        ))
    }
}
