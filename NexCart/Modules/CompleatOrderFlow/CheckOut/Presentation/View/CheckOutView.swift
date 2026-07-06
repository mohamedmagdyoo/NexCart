//
//  CheckOutView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

// CheckoutView.swift
import SwiftUI

struct CheckoutView: View {
    @StateObject var viewModel: CheckoutViewModel
    let total: Double
    
    var body: some View {
        ZStack {
            loadedContent
        }
        .navigationDestination(isPresented: $viewModel.navToNextScreen){
            VStack{
                //Here have to call the next actule screen
                Text("Let's Confierm the order")
            }
        }
        .navigationTitle("Checkout")
        .onAppear { viewModel.onAppear() }
    }
    
    private var loadedContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                //Address Section
                addressSection
                    .padding(.bottom, 20)
                
                //Payment Section
                paymentSection
                
                //Total Price
                totalRow
                
                // Shoing Error If Found
                if viewModel.screenError != nil{
                    Text(viewModel.screenError!)
                        .foregroundColor(.red)
                }
                
                //Confirme Order Button
                Button(action: {
//                    viewModel.testPay(total: 1000)
                    viewModel.didConfirmeButtonCliked()
                }) {
                    Text("Confirm Order · $\(total, specifier: "%.2f")")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppColor.pillSel)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 8)
            }
            .padding()
        }
    }
    
    // MARK: - Address
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Shipping address", systemImage: "mappin.and.ellipse")
                .font(.headline)
            
            if viewModel.addresses.isEmpty{
                VStack{
                    Text("No address to select")
                }
            }else{
                ForEach(Array(viewModel.addresses.enumerated()), id: \.element.id) { index, address in
                    addressRow(address, isSelected: index == 0)
                }
            }
        }
    }
    
    private func addressRow(_ address: AddressEntity, isSelected: Bool) -> some View {
        Button {
            viewModel.onAddressSelected(address)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(address.fullName)
                    .font(.body).bold()
                    .foregroundStyle(.primary)
                Text(address.streetAddress)
                    .foregroundStyle(.secondary)
                Text("\(address.city), \(address.state) \(address.zip)")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.orange : Color(.separator), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Payment
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Payment", systemImage: "creditcard")
                .font(.headline)
            
            ForEach(viewModel.paymentMethods, id: \.type) { method in
                paymentRow(method)
            }
        }
    }
    
    private func paymentRow(_ method: PaymentMethod) -> some View {
        let isSelected = viewModel.selectedPaymentMethod == method.type
        return Button {
            viewModel.onPaymentMethodSelected(method.type)
        } label: {
            HStack {
                Text(method.displayName)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .orange : .secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.orange : Color(.separator), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Total
    private var totalRow: some View {
        HStack {
            Text("Total")
                .bold()
                .foregroundStyle(.secondary)
            Spacer()
            Text(total, format: .currency(code: "USD"))
                .font(.title2.bold())
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .foregroundStyle(.secondary)
            Button("Retry") { viewModel.onAppear() }
        }
    }
}
