//
//  CheckOutViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation

@MainActor
final class CheckoutViewModel: ObservableObject {
    
    @Published var addresses: [AddressEntity] = []
    @Published var paymentMethods: [PaymentMethod] = []
    
    @Published var selectedPaymentMethod: PaymentMethodType = .cashOnDelivery
    @Published var selectedAddress: AddressEntity? = nil
    
    @Published var screenError: String? = nil
    @Published var navToNextScreen: Bool = false
    
    
    private var ownerID: String{
        return AppConstants.shared.getUserEntity()?.id ?? "0"
    }

    
    private let getAllAddressesUseCase: GetAllAddressesUseCase
    private let selectAddressUseCase: SelectAddressUseCaseProtocol
    private let getPaymentMethodsUseCase: GetPaymentMethodsUseCaseProtocol
    private let selectPaymentMethodUseCase: SelectPaymentMethodUseCaseProtocol
    
    init(
        getAllAddressesUseCase: GetAllAddressesUseCase,
        selectAddressUseCase: SelectAddressUseCaseProtocol,
        getPaymentMethodsUseCase: GetPaymentMethodsUseCaseProtocol,
        selectPaymentMethodUseCase: SelectPaymentMethodUseCaseProtocol) {
            self.getAllAddressesUseCase = getAllAddressesUseCase
            self.selectAddressUseCase = selectAddressUseCase
            self.getPaymentMethodsUseCase = getPaymentMethodsUseCase
            self.selectPaymentMethodUseCase = selectPaymentMethodUseCase
        }
    
    func didConfirmeButtonCliked(){
        if selectedAddress != nil{
            navToNextScreen = true
        }else{
            screenError = "Select An Address First"
        }
    }
    
    func onAppear() {
        paymentMethods = getPaymentMethodsUseCase.execute()
        Task { await loadAddresses() }
        
    }
    
    private func loadAddresses() async {
        do {
            addresses = try await getAllAddressesUseCase.execute(ownerID: ownerID )
            selectedAddress = addresses.first
            print("\(selectedAddress?.city)")
        } catch {
            screenError = "Couldn't load your addresses."
            
        }
    }
    
    func onAddressSelected(_ address: AddressEntity) {
        Task {
            do {
                addresses = try await selectAddressUseCase.execute(ownerID: ownerID , selected: address)
            } catch {
                screenError = "Couldn't select that address."
            }
        }
    }
    
    func onPaymentMethodSelected(_ type: PaymentMethodType) {
        if let method = selectPaymentMethodUseCase.execute(method: type, from: paymentMethods) {
            selectedPaymentMethod = method.type
        }
    }
    
    //Just Example on test the payment
    func testPay(total: Double){
        let payWithAppleUseCse = ProcessPaymentWithApplePayUseCase(paymentRepository: PaymentRepositoryImpl(applePayService: ApplePayService()))
        
        Task{
            do{
                let payResult = try await payWithAppleUseCse.execute(total: total, currency: "USD", merchantIdentifier: "d")
                
                print("payResult")
                print(payResult.method)
                print(payResult.network!)
                print(payResult.paymentTokenData!)
                print(payResult.transactionId!)
                print(payResult.timestamp)
            }catch{
                print("ErrorWith ThePaymentExcute \(error.localizedDescription)")
            }
        }
    }
}
