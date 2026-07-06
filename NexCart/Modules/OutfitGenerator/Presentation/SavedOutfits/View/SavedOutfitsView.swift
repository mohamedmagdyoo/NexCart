//
//  SavedOutfitsView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import SwiftUI

struct SavedOutfitsView: View {
    @StateObject var viewModel: SavedOutfitsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            GoldBackButton()
                .padding(.leading, 10)
            
            Text("Saved Outfits")
                .font(.system(size: 28, weight: .heavy, design: .default))
                .padding(.leading, 10)
                .padding(.bottom, 4)
            
            if viewModel.savedOutfits.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.savedOutfits, id: \.id) { outfit in
                        NavigationLink {
                            SavedOutfitDetailView(outfit: outfit)
                        } label: {
                            SavedOutfitRow(outfit: outfit)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task { await viewModel.delete(id: outfit.id) }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.loadSavedOutfits()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tshirt")
                .font(.system(size: 44))
                .foregroundColor(.secondary)
            Text("No saved outfits yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SavedOutfitDetailView: View {
    let outfit: GeneratedOutfit
    
    var body: some View {
        VStack {
            
            if let uiImage = UIImage(data: outfit.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 220, height: 480)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        Spacer()
    }
}


struct SavedOutfitRow: View {
    var outfit: GeneratedOutfit
    
    var body: some View {
        HStack(spacing: 12) {
            if let uiImage = UIImage(data: outfit.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(outfit.name ?? "Untitled")
                    .font(.subheadline.bold())
                Text(outfit.generatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
