import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var product: ProductEntity

    @State private var selectedSize: String = ""
    @State private var selectedColor: String = ""
    @State private var isFavorited: Bool = false
    @State private var currentImageIndex: Int = 0
    @State private var quantity: Int = 1
    @StateObject private var productDetailsViewModel: ProductDetailViewModel

    init(product: ProductEntity, productViewModel: ProductDetailViewModel) {
        _product = State(initialValue: product)
        _productDetailsViewModel = StateObject(wrappedValue: productViewModel)
    }

    private var sizes: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Size") == .orderedSame })?.values ?? []
    }

    private var colors: [String] {
        product.options.first(where: { $0.name.caseInsensitiveCompare("Color") == .orderedSame })?.values ?? []
    }

    private var images: [ProductImageEntity] { product.images }

    private var selectedVariant: VariantEntity? {
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
            .ignoresSafeArea(edges: .top)

            bottomBar

            if success {
                VStack {
                    Spacer()
                    ToastView(message: "Added to bag")
                        .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: success)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
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
            TabView(selection: $currentImageIndex) {
                ForEach(images.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: images[index].src)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        AppColor.surface
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
            .clipped()

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)

            HStack {
                CircleNavButton(systemName: "chevron.left") {
                    presentationMode.wrappedValue.dismiss()
                }

                Spacer()

                HStack(spacing: 12) {
                    CircleNavButton(systemName: "square.and.arrow.up") {}

                    CircleNavButton(systemName: isFavorited ? "heart.fill" : "heart") {
                        withAnimation(.spring()) {
                            isFavorited.toggle()
                        }
                    }
                    .foregroundColor(isFavorited ? AppColor.gold : AppColor.textPrim)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
        .frame(height: UIScreen.main.bounds.height * 0.55)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.vendor.uppercased())
                            .font(AppColor.sans(14, .bold))
                            .foregroundColor(AppColor.textSec)
                            .tracking(2.0)

                        Text(product.name)
                            .font(AppColor.serif(28))
                            .foregroundColor(AppColor.textPrim)
                            .lineSpacing(4)
                    }

                    Spacer()
                }

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: "$%.2f", displayPrice))
                            .font(AppColor.sans(32, .bold))
                            .foregroundColor(AppColor.textPrim)

                        if let compareAt = selectedVariant?.compareAtPrice ?? product.variants.first?.compareAtPrice {
                            Text("$\(compareAt)")
                                .font(AppColor.sans(16))
                                .foregroundColor(AppColor.textSec)
                                .strikethrough(true, color: AppColor.textSec)
                        }
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColor.gold)
                        Text("4.8")
                            .font(AppColor.sans(16, .bold))
                            .foregroundColor(AppColor.textPrim)
                        Text("(\(203))")
                            .font(AppColor.sans(14))
                            .foregroundColor(AppColor.textSec)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColor.surface)
                    .clipShape(Capsule())
                }

                Divider()
                    .background(AppColor.border)

                if !colors.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Color")
                            .font(AppColor.serif(18))
                            .foregroundColor(AppColor.textPrim)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(colors, id: \.self) { color in
                                    ColorCircle(
                                        colorName: color,
                                        isSelected: selectedColor == color,
                                        onSelect: { withAnimation { selectedColor = color } }
                                    )
                                }
                            }
                        }
                    }
                }

                if !sizes.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Size")
                                .font(AppColor.serif(18))
                                .foregroundColor(AppColor.textPrim)
                            Spacer()
                            Text("Size Guide")
                                .font(AppColor.sans(14, .medium))
                                .foregroundColor(AppColor.textPrim)
                                .underline()
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(sizes, id: \.self) { size in
                                    SizeCircle(
                                        size: size,
                                        isSelected: selectedSize == size,
                                        onSelect: { withAnimation { selectedSize = size } }
                                    )
                                }
                            }
                        }
                    }
                }

                if let bodyHtml = product.bodyHtml {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(AppColor.serif(18))
                            .foregroundColor(AppColor.textPrim)

                        Text(bodyHtml)
                            .font(AppColor.sans(15))
                            .foregroundColor(AppColor.textSec)
                            .lineSpacing(6)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Quantity")
                        .font(AppColor.serif(18))
                        .foregroundColor(AppColor.textPrim)

                    QuantitySelector(quantity: $quantity, maxQuantity: nil)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppColor.sans(14, .medium))
                        .foregroundColor(AppColor.tagSold)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)
            .padding(.bottom, 140)
        }
        .background(AppColor.bg)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .offset(y: -40)
        .shadow(color: Color.black.opacity(0.06), radius: 24, x: 0, y: -8)
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider().background(AppColor.border)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(AppColor.sans(12, .medium))
                        .foregroundColor(AppColor.textSec)
                        .tracking(1)
                    Text(String(format: "$%.2f", displayPrice))
                        .font(AppColor.sans(24, .bold))
                        .foregroundColor(AppColor.textPrim)
                }
                .padding(.leading, 24)

                Spacer()

                Button {
                    guard let variantID = selectedVariant?.id else { return }
                    Task {
                        await productDetailsViewModel.addToCart(
                            variantID: variantID,
                            customerID: 111,
                            quantity: quantity
                        )
                    }
                } label: {
                    HStack(spacing: 12) {
                        if isAddingToCart {
                            ProgressView().tint(AppColor.white)
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColor.white)
                            Text("Add to Bag")
                                .font(AppColor.sans(16, .bold))
                                .foregroundColor(AppColor.white)
                        }
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 32)
                    .background(AppColor.textPrim)
                    .clipShape(Capsule())
                    .shadow(color: AppColor.textPrim.opacity(0.25), radius: 12, x: 0, y: 6)
                }
                .disabled(isAddingToCart)
                .opacity(isAddingToCart ? 0.6 : 1)
                .padding(.trailing, 24)
            }
            .padding(.vertical, 16)
            .background(AppColor.bg)
            .padding(.bottom, bottomSafeArea())
        }
        .background(AppColor.bg)
        .shadow(color: Color.black.opacity(0.04), radius: 16, x: 0, y: -4)
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
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 44, height: 44)
                .background(AppColor.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
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
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(isSelected ? AppColor.textPrim : AppColor.border, lineWidth: isSelected ? 2.5 : 1)
                        .padding(isSelected ? -4 : 0)
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
                .font(AppColor.sans(15, isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? AppColor.white : AppColor.textPrim)
                .frame(width: 56, height: 56)
                .background(isSelected ? AppColor.textPrim : AppColor.bg)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.clear : AppColor.border, lineWidth: 1.5)
                )
                .shadow(color: isSelected ? AppColor.textPrim.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
        }
    }
}
