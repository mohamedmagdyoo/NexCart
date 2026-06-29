import SwiftUI

struct ProductDetailView: View {
    @State private var product: Product

    @State private var selectedSize: String = ""
    @State private var selectedColor: String = ""
    @State private var isFavorited: Bool = false
    @State private var currentImageIndex: Int = 0
    @State private var quantity: Int = 1
    @StateObject private var productDetailsViewModel: ProductDetailViewModel

    init(product: Product, productViewModel: ProductDetailViewModel) {
        _product = State(initialValue: product)
        _productDetailsViewModel = StateObject(wrappedValue: productViewModel)
    }

    private var sizes: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Size") == .orderedSame })?.values ?? []
    }

    private var colors: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Color") == .orderedSame })?.values ?? []
    }

    private var images: [ProductImage] { product.images }

    private var selectedVariant: Variant? {
        product.variants.first { variant in
            let matchesSize = selectedSize.isEmpty || variant.option1 == selectedSize || variant.option2 == selectedSize || variant.option3 == selectedSize
            let matchesColor = selectedColor.isEmpty || variant.option1 == selectedColor || variant.option2 == selectedColor || variant.option3 == selectedColor
            return matchesSize && matchesColor
        }
    }

    private var isAddingToCart: Bool {
        if case .loading = productDetailsViewModel.screenState { return true }
        return false
    }

    private var errorMessage: String? {
        if case .error(let error) = productDetailsViewModel.screenState { return error.localizedDescription }
        return nil
    }

    private var success: Bool {
        if case .success = productDetailsViewModel.screenState { return true }
        return false
    }

    private var displayPrice: Double {
        (Double(selectedVariant?.price ?? product.variants.first?.price ?? "0") ?? 0) * Double(quantity)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    imageSection
                    contentCard
                }
            }

            bottomBar

            if success {
                VStack {
                    Spacer()
                    ToastView(message: "Added to bag")
                        .padding(.bottom, 90)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.25), value: success)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            selectedSize = sizes.first ?? ""
            selectedColor = colors.first ?? ""
        }
        .onChange(of: selectedVariant?.id) { _ in
            quantity = 1
        }
    }

    private var imageSection: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: images.indices.contains(currentImageIndex) ? images[currentImageIndex].src : "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                AppColor.surface
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.62)
            .clipped()

            HStack {
                CircleNavButton(systemName: "chevron.left") {
                    guard !images.isEmpty else { return }
                    currentImageIndex = (currentImageIndex - 1 + images.count) % images.count
                }

                Spacer()

                HStack(spacing: 10) {
                    CircleNavButton(systemName: "square.and.arrow.up") {}

                    CircleNavButton(systemName: isFavorited ? "heart.fill" : "heart") {
                        isFavorited.toggle()
                    }
                    .foregroundColor(isFavorited ? AppColor.gold : AppColor.textPrim)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
        }
        .frame(height: UIScreen.main.bounds.height * 0.62)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.vendor.uppercased())
                            .font(AppColor.sans(12, .semibold))
                            .foregroundColor(AppColor.textSec)
                            .tracking(1.2)

                        Text(product.title)
                            .font(AppColor.serif(28))
                            .foregroundColor(AppColor.textPrim)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "$%.0f", displayPrice))
                            .font(AppColor.sans(26, .semibold))
                            .foregroundColor(AppColor.textPrim)

                        if let compareAt = selectedVariant?.compareAtPrice ?? product.variants.first?.compareAtPrice {
                            Text("$\(compareAt)")
                                .font(AppColor.sans(15))
                                .foregroundColor(AppColor.textSec)
                                .strikethrough(true, color: AppColor.textSec)
                        }
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13))
                        .foregroundColor(AppColor.gold)
                    Text("4.8")
                        .font(AppColor.sans(14, .semibold))
                        .foregroundColor(AppColor.textPrim)
                    Text("· \(203) reviews")
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                }

                Divider()
                    .background(AppColor.border)

                if !colors.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .font(AppColor.serif(17))
                            .foregroundColor(AppColor.textPrim)

                        HStack(spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                ColorCircle(
                                    colorName: color,
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
                            Text("Size")
                                .font(AppColor.serif(17))
                                .foregroundColor(AppColor.textPrim)
                            Spacer()
                            Text("Size guide")
                                .font(AppColor.sans(13))
                                .foregroundColor(AppColor.gold)
                        }

                        HStack(spacing: 10) {
                            ForEach(sizes, id: \.self) { size in
                                SizeCircle(
                                    size: size,
                                    isSelected: selectedSize == size,
                                    onSelect: { selectedSize = size }
                                )
                            }
                        }
                    }
                }

                if let bodyHtml = product.bodyHtml {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(AppColor.serif(17))
                            .foregroundColor(AppColor.textPrim)

                        Text(bodyHtml)
                            .font(AppColor.sans(15))
                            .foregroundColor(AppColor.textSec)
                            .lineSpacing(5)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quantity")
                        .font(AppColor.serif(17))
                        .foregroundColor(AppColor.textPrim)

                    QuantitySelector(quantity: $quantity, maxQuantity: nil)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.tagSold)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 28)
            .padding(.bottom, 100)
        }
        .background(AppColor.bg)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .offset(y: -28)
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider().background(AppColor.border)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("TOTAL")
                        .font(AppColor.sans(11, .semibold))
                        .foregroundColor(AppColor.textSec)
                        .tracking(1)
                    Text(String(format: "$%.0f", displayPrice))
                        .font(AppColor.sans(20, .bold))
                        .foregroundColor(AppColor.textPrim)
                }
                .padding(.leading, 20)

                Spacer()

                Button {
                    guard let variantID = selectedVariant?.id else { return }
                    Task {
                        print("cal")
                        await productDetailsViewModel.addToCart(
                            variantID: variantID,
                            customerID: 111,
                            quantity: quantity
                        )
                    }
                } label: {
                    HStack(spacing: 8) {
                        if isAddingToCart {
                            ProgressView().tint(AppColor.white)
                        } else {
                            Image(systemName: "bag")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColor.white)
                            Text("Add to bag")
                                .font(AppColor.sans(16, .semibold))
                                .foregroundColor(AppColor.white)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(AppColor.textPrim)
                    .clipShape(Capsule())
                }
                .disabled(isAddingToCart)
                .opacity(isAddingToCart ? 0.6 : 1)
                .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .background(AppColor.bg)
            .padding(.bottom, bottomSafeArea())
        }
        .background(AppColor.bg)
    }

    private func bottomSafeArea() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

private struct CircleNavButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 40, height: 40)
                .background(AppColor.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

private struct ColorCircle: View {
    let colorName: String
    let isSelected: Bool
    let onSelect: () -> Void

    private var swatchColor: Color {
        switch colorName.lowercased() {
        case "white": return Color(hex: "#F5F0E8")
        case "black": return Color(hex: "#2C2C2C")
        case "beige", "cream": return Color(hex: "#E8DDD0")
        case "brown", "tan": return Color(hex: "#8B7355")
        case "olive", "khaki": return Color(hex: "#8B8560")
        case "navy": return Color(hex: "#1B2A4A")
        case "grey", "gray": return Color(hex: "#9E9E9E")
        default: return AppColor.surface
        }
    }

    var body: some View {
        Button(action: onSelect) {
            Circle()
                .fill(swatchColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(isSelected ? AppColor.gold : AppColor.border, lineWidth: isSelected ? 2 : 1)
                        .padding(isSelected ? -3 : 0)
                )
        }
    }
}

private struct SizeCircle: View {
    let size: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Text(size)
                .font(AppColor.sans(14, isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? AppColor.white : AppColor.textPrim)
                .frame(width: 52, height: 52)
                .background(isSelected ? AppColor.textPrim : AppColor.bg)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.clear : AppColor.border, lineWidth: 1)
                )
        }
    }
}
