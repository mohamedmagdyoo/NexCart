//
//  OutfitSelectionContentView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import SwiftUI

struct OutfitSelectionContentView: View {
    @ObservedObject var viewModel: OutfitGeneratorViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 16) {
                if viewModel.selectedProducts.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.selectedProducts, id: \.id) { product in
                            SelectedProductCard(product: product) {
                                Task { await viewModel.removeProduct(id: product.id) }
                            }
                        }
                    }
                    .padding()
                    
                    Button {
                        Task { await viewModel.generateOutfit() }
                    } label: {
                        Text("Generate Outfit")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.selectedProducts.isEmpty ? Color.gray.opacity(0.4) : Color.black)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(viewModel.selectedProducts.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tshirt")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("No products selected yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
}

struct SelectedProductCard: View {
    let product: SelectedProduct
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                }
                .padding(6)
            }
            
            Text(product.title)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
