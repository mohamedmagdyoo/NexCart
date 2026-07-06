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
