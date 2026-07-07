//
//  OutfitGeneratorView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import SwiftUI

struct OutfitGeneratorView: View {
    @StateObject var viewModel: OutfitGeneratorViewModel
    @State private var navigateToSaved = false

    var body: some View {
        VStack(alignment: .leading) {
            topBar
            modelPicker
            content
        }
        .padding()
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateToSaved) {
            SavedOutfitsView(viewModel: DIContainer.shared.container.resolve(SavedOutfitsViewModel.self)!)
        }
        .task {
            await viewModel.loadSelectedProducts()
        }
    }

    private var topBar: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 22) {
                GoldBackButton()

                Text("Outfit Generator")
                    .font(.system(size: 28, weight: .heavy, design: .default))
            }

            Spacer()

            Button {
                navigateToSaved = true
            } label: {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            }
        }
    }
    private var modelPicker: some View {
           VStack(alignment: .leading, spacing: 8) {
               Text("AI MODEL")
                   .font(AppColor.sans(10, .semibold))
                   .tracking(2.5)
                   .foregroundColor(AppColor.textSec)
    
               HStack(spacing: 10) {
                   ForEach(AIProviderType.allCases) { provider in
                       providerCard(provider)
                   }
               }
           }
       }
    
       private func providerCard(_ provider: AIProviderType) -> some View {
           let isSelected = viewModel.selectedProvider == provider
    
           return Button {
               withAnimation(.spring(response: 0.25)) {
                   viewModel.selectedProvider = provider
               }
           } label: {
               HStack(spacing: 8) {
                   Image(systemName: provider.iconName)
                       .font(.system(size: 13, weight: .semibold))
                       .foregroundColor(isSelected ? .white : AppColor.textSec)
    
                   VStack(alignment: .leading, spacing: 1) {
                       Text(provider.rawValue)
                           .font(AppColor.sans(13, .semibold))
                           .foregroundColor(isSelected ? .white : AppColor.textPrim)
                       Text(provider.description)
                           .font(AppColor.sans(10))
                           .foregroundColor(isSelected ? .white.opacity(0.75) : AppColor.textSec)
                   }
    
                   Spacer()
    
                   if isSelected {
                       Image(systemName: "checkmark.circle.fill")
                           .font(.system(size: 14))
                           .foregroundColor(.white)
                   }
               }
               .padding(.horizontal, 14)
               .padding(.vertical, 10)
               .background(
                   RoundedRectangle(cornerRadius: 12, style: .continuous)
                       .fill(isSelected ? AppColor.textPrim : AppColor.card)
                       .overlay(
                           RoundedRectangle(cornerRadius: 12, style: .continuous)
                               .stroke(isSelected ? Color.clear : AppColor.border, lineWidth: 1)
                       )
               )
           }
           .buttonStyle(PlainButtonStyle())
           .frame(maxWidth: .infinity)
       }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .selection:
            OutfitSelectionContentView(viewModel: viewModel)
        case .loading:
            OutfitGenerationLoadingView()
        case .success(let outfit):
            OutfitResultView(outfit: outfit, viewModel: viewModel)
        case .error(let message):
            OutfitErrorView(message: message) {
                viewModel.state = .selection
            }
        }
    }
}
