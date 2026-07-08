//
//  FavProductsScreen.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.


import SwiftUI

private extension Color {
    static var favBackground: Color { AppColor.bg }
    static var favCard: Color { AppColor.card }
    static var favTextPrimary: Color { AppColor.textPrim }
    static var favTextSecondary: Color { AppColor.textSec }
    static var favRemoveBg: Color { AppColor.surface }
}

struct FavProductsScreen: View {
    
    @StateObject private var viewModel: FavProductsViewModel = DIContainer.shared.container.resolve(FavProductsViewModel.self)!
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var selectedProduct: ProductEntity?
    @ObservedObject private var appSettings = AppSettings.shared
    
    

    var body: some View {
        ZStack {
            Color.favBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                switch viewModel.screenStates {
                case .loading:
                    FavScreenLoadingState()
                case .empty:
                    FavScreenEmptyState()
                case .succes:
                    FavScreenSuccesState(viewModel: viewModel, selectedProduct: $selectedProduct)
                }
            }
        }
        .background(
            Group {
                if let product = selectedProduct {
                    NavigationLink(
                        destination: ProductDetailView(
                            product: product,
                            productViewModel: DIContainer.shared.container.resolve(ProductDetailViewModel.self)!
                        ),
                        isActive: Binding(
                            get: { selectedProduct != nil },
                            set: { if !$0 { selectedProduct = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                }
            }
        )
        .onAppear {
            viewModel.onAppear()
            tabBarManager.isHidden = false
        }
        .onChange(of: selectedProduct) { newValue in
            tabBarManager.isHidden = (newValue != nil)
        }
        .navigationTitle("")
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.description),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(appSettings.loc("Favorites", "المفضلة"))
                .font(.system(.largeTitle, design: .serif))
                .foregroundColor(.favTextPrimary)
            
            Spacer()
            
            Text(appSettings.loc("\(viewModel.favProducts.count) piece\(viewModel.favProducts.count == 1 ? "" : "s")", "\(viewModel.favProducts.count) قطع"))
                .font(.subheadline)
                .foregroundColor(.favTextSecondary)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
}

struct FavScreenSuccesState: View {
    @ObservedObject var viewModel: FavProductsViewModel
    @Binding var selectedProduct: ProductEntity?
    @ObservedObject private var appSettings = AppSettings.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(viewModel.favProducts) { product in
                    FavProductRow(
                        product: product,
                        onTap: {
                            Task {
                                if let entity = await viewModel.fetchAndNavigate(to: product) {
                                    selectedProduct = entity
                                }
                            }
                        },
                        onRemove: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.didTapToDelete(product: product)
                            }
                        }
                    )
                }
                
                Color.clear
                    .frame(height: 100)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .alert(AppSettings.shared.loc("Remove Favorite", "حذف المفضلة"), isPresented: $viewModel.showRemoveAlert){
            Button(AppSettings.shared.loc("Ok", "حسناً"), role: .cancel){
                viewModel.confirmRemoveProduct()
            }
            Button(AppSettings.shared.loc("Cancel", "إلغاء"), role: .destructive){}
        }
        
    }
}

private struct FavProductRow: View {
    let product: FavProduct
    let onTap: () -> Void
    let onRemove: () -> Void
    @ObservedObject private var appSettings = AppSettings.shared
    
    var body: some View {
        HStack(spacing: 14) {
            productImage
                .onTapGesture(perform: onTap)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand.uppercased())
                    .font(.caption2)
                    .tracking(1)
                    .foregroundColor(.favTextSecondary)
                
                Text(product.name)
                    .font(.system(.body, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(.favTextPrimary)
                
                Text(formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.favTextSecondary)
            }
            .onTapGesture(perform: onTap)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.favTextSecondary)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.favRemoveBg))
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.favCard)
        )
    }
    
    private var productImage: some View {
        AsyncImage(url: URL(string: product.imageURL)) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            default:
                Color.favRemoveBg
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
    
    private var formattedPrice: String {
        product.price.formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
}

private extension FavProduct {
    func toProductEntity() -> ProductEntity {
        ProductEntity(
            id: id,
            brand: brand,
            name: name,
            price: price,
            originalPrice: nil,
            imageURL: imageURL,
            tag: nil,
            isFavorited: true,
            
            bodyHtml: nil,
            vendor: brand,
            productType: "",
            createdAt: "",
            handle: "",
            updatedAt: "",
            publishedAt: nil,
            publishedScope: "",
            tags: nil,
            status: "",
            
            variants: [],
            options: [],
            images: [],
            image: nil
        )
    }
}

struct FavScreenLoadingState: View {
    @ObservedObject private var appSettings = AppSettings.shared
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.favTextSecondary)
            Spacer()
        }
    }
}

struct FavScreenEmptyState: View {
    @ObservedObject private var appSettings = AppSettings.shared
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "heart")
                .font(.system(size: 36, weight: .light))
                .foregroundColor(.favTextSecondary)
            Text(AppSettings.shared.loc("No saved pieces yet", "لا توجد عناصر محفوظة"))
                .font(.system(.body, design: .serif))
                .foregroundColor(.favTextPrimary)
            Text(AppSettings.shared.loc("Items you save will show up here.", "العناصر التي تحفظها ستظهر هنا."))
                .font(.subheadline)
                .foregroundColor(.favTextSecondary)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
}

struct FavProductsScreen_Previews: PreviewProvider {
    final class PreviewFetchUseCase: FetchFavProductsUseCaseProtocol {
        func execute() throws -> [FavProduct] {
            [
                FavProduct(id: 1, brand: "Atlas Studio", name: "Linen Camp Shirt", price: 89, imageURL: ""),
                FavProduct(id: 2, brand: "Form & Field", name: "Wide Leg Trouser", price: 145, imageURL: ""),
                FavProduct(id: 3, brand: "North Standard", name: "Tailored Wool Coat", price: 320, imageURL: "")
            ]
        }
    }
    
    final class PreviewRemoveUseCase: RemoveFavProductUseCaseProtocol {
        func execute(productId: Int) throws {}
    }
    
    

    static var previews: some View {
        FavProductsScreen()
    }
}
