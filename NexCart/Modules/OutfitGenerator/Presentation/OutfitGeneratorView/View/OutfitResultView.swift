//
//  OutfitResultView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import SwiftUI

struct OutfitResultView: View {
    let outfit: GeneratedOutfit
    @ObservedObject var viewModel: OutfitGeneratorViewModel

    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                if let uiImage = UIImage(data: outfit.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                }
                
                HStack(spacing: 16) {
                    Button {
                        viewModel.cancelResult()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button {
                        viewModel.beginSave()
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $viewModel.showSaveSheet) {
            SaveOutfitSheet(viewModel: viewModel)
                .presentationDetents([.height(220)])
        }
    }
}

struct SaveOutfitSheet: View {
    @ObservedObject var viewModel: OutfitGeneratorViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Save Outfit")
                .font(.headline)

            TextField("Outfit name", text: $viewModel.outfitName)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .padding(.horizontal)

            Button {
                Task { await viewModel.confirmSave() }
            } label: {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.outfitName.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color.gray.opacity(0.4) : Color.black
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(viewModel.outfitName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal)
        }
        .padding(.top, 24)
        .onAppear { isFocused = true }
    }
}
