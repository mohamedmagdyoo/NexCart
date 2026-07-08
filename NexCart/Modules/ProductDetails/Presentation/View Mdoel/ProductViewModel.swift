//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Antoneos Philip on 27/06/2026.
//

import Foundation
enum ProductDetailScreenState {
    case idle
    case loading
    case success
    case error(data:any Error)
}


@MainActor
final class ProductDetailViewModel: ObservableObject, ProductDetailsViewModelProtocol {
    
    private let addCartUseCase: AddCartUseCase
    private let cartUseCase: CartUseCaseProtocol
    private let coreDataService = CoreDataService.shared
    @Published var screenState: ProductDetailScreenState = .idle
    @Published var numberOfStudioProducts: Int = 0
    @Published var toastMessage: String = ""
    var currentDraftOrder: DraftOrder?
    
    //UseCasee for AiStudio   
    private let addProductToStudioUseCase: AddProductToSelectionUseCaseProtocol
    private let getSelectedProductsUseCase: GetSelectedProductsUseCaseProtocol
    
    init(addCartUseCase: AddCartUseCase, cartUseCase: CartUseCaseProtocol, addProductToStudioUseCase: AddProductToSelectionUseCaseProtocol, getSelectedProductsUseCase: GetSelectedProductsUseCaseProtocol) {
        self.addCartUseCase = addCartUseCase
        self.cartUseCase = cartUseCase
        self.addProductToStudioUseCase = addProductToStudioUseCase
        self.getSelectedProductsUseCase = getSelectedProductsUseCase
    }
    
    func addToAiStudio(prodcut: ProductEntity){
        
        Task{
            do{
                try await addProductToStudioUseCase.execute(product: prodcut.toSelectedProduct())
                getStudioProductsCount()
            }catch let selectionError as SelectionError{
                switch selectionError{
                case .maximumReached:
                    toastMessage = "Maximum Reached"
                case .alreadyAdded:
                    toastMessage = "Already Added"
                }
                
            }
        }
        
    }
    
    func getStudioProductsCount(){
        Task{
            let studioProducts = await getSelectedProductsUseCase.execute()
            numberOfStudioProducts = studioProducts.count
        }
    }
    
    func toggleFavorite(product: ProductEntity) {
        if product.isFavorited {
            coreDataService.saveProductToDatabase(product: product)
        } else {
            coreDataService.deleteProductFromDatabase(id: product.id)
        }
    }
    
    func addToCart(variantID: Int, customerID: Int, quantity: Int) async {
        screenState = .loading
        print("🛒 Adding to cart - variantID: \(variantID), customerID: \(customerID)")
        do {
            let result = try await addCartUseCase.addToCart(
                variantID: variantID,
                customerID: customerID,
                quantity: quantity
            )
            print("✅ Added to cart - draftOrderId: \(result.id)")
            currentDraftOrder = result
            toastMessage = "Added to bag"
            screenState = .success
        } catch {
            print("❌ Add to cart failed: \(error)")
            screenState = .error(data: error)
        }
    }
    
    func updateCartQuantity(quantity: Int) async {
        guard let draftOrder = currentDraftOrder, let item = draftOrder.items.first else { return }
        
        do {
            let payload = [
                DraftOrderLineItemUpdate(
                    id: item.id,
                    variantId: item.variantID,
                    quantity: quantity
                )
            ]
            let updatedBag = try await cartUseCase.updateQuantity(
                draftOrderId: String(draftOrder.id),
                lineItems: payload
            )
            
          
            let updatedItems = updatedBag.items.map {
                DraftOrderItem(
                    id: $0.id,
                    productID: 0,
                    variantID: $0.variantId ?? 0,
                    title: $0.title,
                    quantity: $0.quantity,
                    price: String($0.price)
                )
            }
            currentDraftOrder = DraftOrder(id: updatedBag.id, status: "", totalPrice: String(updatedBag.total), items: updatedItems)
        } catch {
            print("❌ Update quantity failed: \(error)")
        }
    }
}
