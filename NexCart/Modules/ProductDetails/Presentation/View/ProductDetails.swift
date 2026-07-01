//
//  ProductDetails.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.


import SwiftUI

struct ProductDetailView: View {
    @State private var product: Product // you have to take the product details from the vm
    
    @State private var selectedSize: String = ""
    @State private var selectedColor: String = ""
    @State private var isFavorited: Bool = false
    @State private var currentImageIndex: Int = 0
    
    init(product: Product) {
        _product = State(initialValue: product)
    }
    
    private var sizes: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Size") == .orderedSame })?.values ?? []
    }
    
    private var colors: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Color") == .orderedSame })?.values ?? []
    }
    
    private var images: [ProductImage] {
        product.images
    }
    
    private var selectedVariant: Variant? {
        product.variants.first { variant in
            let matchesSize =
            selectedSize.isEmpty ||
            variant.option1 == selectedSize ||
            variant.option2 == selectedSize ||
            variant.option3 == selectedSize
            
            let matchesColor =
            selectedColor.isEmpty ||
            variant.option1 == selectedColor ||
            variant.option2 == selectedColor ||
            variant.option3 == selectedColor
            
            return matchesSize && matchesColor
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColor.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .top) {
                        AsyncImage(url: URL(string: images.indices.contains(currentImageIndex) ? images[currentImageIndex].src : "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ZStack{
                                AppColor.card
                                Text("Loading...")
                                    .font(.system(size: 20,design: .rounded))
                                    .opacity(0.7)
                            }
                        }
                        .frame(height: 420)
                        .clipped()
                        .background(AppColor.card)
                        
                        
                        HStack {
                            NavButton(systemName: "chevron.left") {
                                guard !images.isEmpty else { return }
                                currentImageIndex = (currentImageIndex - 1 + images.count) % images.count
                            }
                            Spacer()
                            NavButton(systemName: "chevron.right") {
                                guard !images.isEmpty else { return }
                                currentImageIndex = (currentImageIndex + 1) % images.count
                            }
                        }
                        .padding(.horizontal, 8)
                        .offset(y: 200)
                        
                        VStack {
                            HStack {
                                Spacer()
                                
                                Button {
                                    isFavorited.toggle()
                                } label: {
                                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                                        .foregroundColor(isFavorited ? AppColor.gold : AppColor.bg)
                                        .padding(10)
                                        .background(AppColor.white)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                ForEach(images.indices, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentImageIndex ? AppColor.gold : AppColor.bg.opacity(0.5))
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(.top, 380)
                        }
                        .frame(height: 420)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(product.vendor.uppercased())
                                .font(AppColor.sans(12, .semibold))
                                .foregroundColor(AppColor.gold)
                                .tracking(1.2)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppColor.gold)
                                Text("4.8")
                                    .font(AppColor.sans(13, .semibold))
                                    .foregroundColor(AppColor.textPrim)
                                Text("(203)")
                                    .font(AppColor.sans(13))
                                    .foregroundColor(AppColor.textSec)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Text(product.title)
                                .font(AppColor.serif(26, .semibold))
                                .foregroundColor(AppColor.textPrim)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("$\(selectedVariant?.price ?? product.variants.first?.price ?? "")")
                                    .font(AppColor.sans(20, .bold))
                                    .foregroundColor(AppColor.gold)
                                
                                if let compareAt = selectedVariant?.compareAtPrice ?? product.variants.first?.compareAtPrice {
                                    Text("$\(compareAt)")
                                        .font(AppColor.sans(14))
                                        .foregroundColor(AppColor.textSec)
                                        .strikethrough()
                                }
                            }
                        }
                        
                        if let bodyHtml = product.bodyHtml {
                            Text(bodyHtml)
                                .font(AppColor.sans(15))
                                .foregroundColor(AppColor.textSec)
                                .lineSpacing(4)
                        }
                        
                        if !colors.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SELECT COLOR")
                                    .font(AppColor.sans(12, .semibold))
                                    .foregroundColor(AppColor.textSec)
                                    .tracking(1)
                                
                                HStack(spacing: 10) {
                                    ForEach(colors, id: \.self) { color in
                                        ColorSwatch(
                                            color: color,
                                            isSelected: selectedColor == color,
                                            onSelect: { selectedColor = color }
                                        )
                                    }
                                }
                            }
                        }
                        
                        if !sizes.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("SELECT SIZE")
                                        .font(AppColor.sans(12, .semibold))
                                        .foregroundColor(AppColor.textSec)
                                        .tracking(1)
                                    
                                    Spacer()
                                    
                                    Text("Size guide")
                                        .font(AppColor.sans(13, .semibold))
                                        .foregroundColor(AppColor.gold)
                                }
                                
                                HStack(spacing: 10) {
                                    ForEach(sizes, id: \.self) { size in
                                        SizePill(
                                            size: size,
                                            isSelected: selectedSize == size,
                                            onSelect: { selectedSize = size }
                                        )
                                    }
                                }
                            }
                        }
                        
                        InfoRow(icon: "shippingbox", text: "Free express shipping worldwide")
                        InfoRow(icon: "checkmark.shield", text: "100% authenticity guaranteed")
                        
                        AddToBagButton()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .background(AppColor.bg)

                }
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            selectedSize = sizes.first ?? ""
            selectedColor = colors.first ?? ""
        }
    }
}
