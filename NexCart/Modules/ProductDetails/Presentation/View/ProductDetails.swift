import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var product: ProductEntity

    @State private var selectedSize: String = ""
    @State private var selectedColor: String = ""
    @State private var isFavorited: Bool = false
    @State private var currentImageIndex: Int = 0
    @State private var quantity: Int = 1
    @State private var addedToBag: Bool = false
    @State private var navigateToCart: Bool = false
    @State private var showToast: Bool = false
    @State private var showGuestAlert: Bool = false
    @State private var navigateToSignIn: Bool = false
    @StateObject private var productDetailsViewModel: ProductDetailViewModel

    init(product: ProductEntity, productViewModel: ProductDetailViewModel) {
        _product = State(initialValue: product)
        _isFavorited = State(initialValue: product.isFavorited)
        _productDetailsViewModel = StateObject(wrappedValue: productViewModel)
    }

    private var currentCustomerId: Int {
        guard let userData = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: userData),
              let shopifyIdStr = user.shopifyCustomerId,
              let id = Int(shopifyIdStr) else {
            return 0
        }
        return id
    }

    private var isGuest: Bool {
        guard let data = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: data)
        else { return true }
        return user.isGuest
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

    private var displayName: String {
        if let range = product.name.range(of: "|") {
            return product.name[range.upperBound...].trimmingCharacters(in: .whitespaces)
        }
        return product.name
    }

    private var isSelectionIncomplete: Bool {
        (!sizes.isEmpty && selectedSize.isEmpty) || (!colors.isEmpty && selectedColor.isEmpty)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.bg.ignoresSafeArea()

            NavigationLink(destination: BagView(), isActive: $navigateToCart) {
                EmptyView()
            }
            .hidden()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    imageSection
                    contentCard
                }
            }
            .ignoresSafeArea(edges: .top)

            bottomBar

            if showToast {
                VStack {
                    Spacer()
                    ToastView(message: productDetailsViewModel.toastMessage)
                        .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: showToast)
            }
        }
        .onAppear {
            productDetailsViewModel.getStudioProductsCount()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .guestAlert(isPresented: $showGuestAlert, navigateToSignIn: $navigateToSignIn)
        .onChange(of: selectedVariant?.id) { _ in
            quantity = 1
            addedToBag = false
        }
        .onChange(of: productDetailsViewModel.toastMessage) { _ in
            if productDetailsViewModel.toastMessage.isEmpty == true {
                return
            }
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                    productDetailsViewModel.toastMessage = ""
                }
            }
        }
        .onChange(of: success) { newValue in
            if newValue {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
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
                    CircleNavButton(systemName: "cart") {
                        if isGuest {
                            showGuestAlert = true
                        } else {
                            navigateToCart = true
                        }
                    }

                    CircleNavButton(
                        systemName: isFavorited ? "heart.fill" : "heart",
                        iconColor: isFavorited ? AppColor.gold : AppColor.textSec
                    ) {
                        if isGuest {
                            showGuestAlert = true
                        } else {
                            withAnimation(.spring()) {
                                isFavorited.toggle()
                                product.isFavorited = isFavorited
                                productDetailsViewModel.toggleFavorite(product: product)
                            }
                        }
                    }

                    Button(action: {
                        productDetailsViewModel.addToAiStudio(prodcut: product)
                    }) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(AppColor.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                            .overlay(alignment: .topTrailing) {
                                Circle()
                                    .foregroundStyle(.red)
                                    .frame(width: 18, height: 18)
                                    .overlay {
                                        Text("\(productDetailsViewModel.numberOfStudioProducts)")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .offset(x: 4, y: -4)
                            }
                    }
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
                        Text(displayName)
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

            VStack(spacing: 14) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Price")
                            .font(AppColor.sans(12, .medium))
                            .foregroundColor(AppColor.textSec)
                            .tracking(1)
                        Text(String(format: "$%.2f", displayPrice))
                            .font(AppColor.sans(24, .bold))
                            .foregroundColor(AppColor.textPrim)
                    }

                    Spacer()

                    if addedToBag {
                        HStack(spacing: 0) {
                            Button {
                                guard quantity > 1, let variantID = selectedVariant?.id else { return }
                                quantity -= 1
                                Task {
                                    await productDetailsViewModel.addToCart(
                                        variantID: variantID,
                                        customerID: currentCustomerId,
                                        quantity: quantity
                                    )
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppColor.textPrim)
                                    .frame(width: 36, height: 40)
                            }

                            Text("\(quantity)")
                                .font(AppColor.sans(15, .bold))
                                .foregroundColor(AppColor.textPrim)
                                .frame(width: 28)

                            Button {
                                guard let variantID = selectedVariant?.id else { return }
                                quantity += 1
                                Task {
                                    await productDetailsViewModel.addToCart(
                                        variantID: variantID,
                                        customerID: currentCustomerId,
                                        quantity: quantity
                                    )
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppColor.textPrim)
                                    .frame(width: 36, height: 40)
                            }
                        }
                        .background(AppColor.pill)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(AppColor.border, lineWidth: 1)
                        )
                    }
                }

                if !addedToBag {
                    Button {
                        if isGuest {
                            showGuestAlert = true
                        } else {
                            guard let variantID = selectedVariant?.id else { return }
                            Task {
                                await productDetailsViewModel.addToCart(
                                    variantID: variantID,
                                    customerID: currentCustomerId,
                                    quantity: quantity
                                )
                                withAnimation {
                                    addedToBag = true
                                }
                            }
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
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isSelectionIncomplete ? AppColor.textPrim.opacity(0.4) : AppColor.textPrim)
                        .clipShape(Capsule())
                        .shadow(color: AppColor.textPrim.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                    .disabled(isAddingToCart || isSelectionIncomplete)
                    .opacity(isAddingToCart ? 0.6 : 1)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
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
    var iconColor: Color = AppColor.textPrim
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconColor)
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
                    Circle().stroke(AppColor.border, lineWidth: 1)
                )
                .padding(5)
                .overlay(
                    Circle()
                        .stroke(AppColor.gold, lineWidth: 1.5)
                        .opacity(isSelected ? 1 : 0)
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
                .frame(width: 44, height: 44)
                .background(isSelected ? AppColor.gold : AppColor.bg)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(AppColor.border, lineWidth: 1)
                )
                .padding(5)
                .overlay(
                    Circle()
                        .stroke(AppColor.gold, lineWidth: 1.5)
                        .opacity(isSelected ? 1 : 0)
                )
        }
    }
}
