//
//  SignInScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

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
struct SignInIdleState: View {
    @ObservedObject var viewModel: SignInViewModel
    
    @State private var navToSignUp: Bool = false
    @State private var didAppear: Bool = false
    
    private var canSubmit: Bool {
        !viewModel.email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.password.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: Title
                Text("Welcome\nback.")
                    .font(.system(size: 38, weight: .bold, design: .serif))
                    .foregroundColor(.authTitle)
                    .lineSpacing(2)
                
                Text("Sign in to continue your wardrobe.")
                    .font(.subheadline)
                    .foregroundColor(.authSubtitle)
                    .padding(.top, 8)
                    .padding(.bottom, 36)
                
                // MARK: Fields
                ObsidianField(label: "EMAIL", placeholder: "hello@maison.co", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                ObsidianField(label: "PASSWORD", placeholder: "••••••••", text: $viewModel.password, isSecure: true)
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
                        credentials: EmailCredentials(email: viewModel.email, password: viewModel.password)
                    )
                } label: {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AuthPrimaryButtonStyle())
                .opacity(canSubmit ? 1 : 0.4)
                .disabled(!canSubmit)
                .animation(.easeOut(duration: 0.2), value: canSubmit)
                
                // MARK: Social Divider
                AuthDivider(text: "OR CONTINUE WITH")
                    .padding(.vertical, 24)
                
                VStack(spacing: 10) {
                    
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
                    .frame(height: 48)
                    .buttonStyle(AuthPrimaryButtonStyle())
                    
                    Button {
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let vc = scene.windows.first?.rootViewController else { return }
                        viewModel.loginWithSocialProvider(provider: .google(vc: vc))
                    } label: {
                        HStack(spacing: 10) {
                            Image("icon_google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text("Google")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 48)
                    .buttonStyle(AuthSocialButtonStyle())
                    
                    // MARK: Footer
                    AuthFooterLink(
                        message: "New here?",
                        linkText: "Create an account"
                    ) {
                        navToSignUp = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)
                    .padding(.bottom, 20)
                    
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        viewModel.loginAsGuest()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 13))
                            Text("Try with guest mode")
                                .font(.system(size: 15, weight: .medium, design: .serif))
                        }
                        .foregroundColor(.authTitle.opacity(0.55))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
            }//VStack
            .padding()
            .padding(.top, 12)
        }
        .opacity(didAppear ? 1 : 0)
        .offset(y: didAppear ? 0 : 12)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                didAppear = true
            }
        }
        .navigationDestination(isPresented: $navToSignUp) {
            SignUpScreen()
        }
    }
    
    private var monogram: some View {
        ZStack {
            Circle()
                .stroke(AppColor.gold.opacity(0.5), lineWidth: 1)
                .frame(width: 46, height: 46)
            Text("N")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundColor(AppColor.gold)
        }
    }
}



// MARK: - Loading State
struct SignInLoadingState: View {
    var body: some View {
        VStack(spacing: 18) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.authTitle)
            Text("Signing in…")
                .font(.system(size: 14, weight: .medium, design: .serif))
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
    
    @State private var didTriggerNavigation: Bool = false

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(AppColor.gold.opacity(0.35), lineWidth: 1)
                    .frame(width: 100, height: 100)
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(.authTitle)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            
            Text("Welcome \(vm.userEntity?.displayName ?? "back").")
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .foregroundColor(.authTitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
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
                guard !Task.isCancelled else { return } // لو الـ task اتكنسل، منكملش
                didTriggerNavigation = true
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
