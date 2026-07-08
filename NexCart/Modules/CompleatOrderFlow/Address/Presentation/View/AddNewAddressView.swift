//
//  AddNewAddressView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import SwiftUI

struct AddNewAddressView: View {
    @ObservedObject var viewModel: AddressViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                AppColor.bg.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("New Address")
                            .font(AppColor.serif(28, .medium))
                            .foregroundColor(AppColor.textPrim)

                        Text("Add a shipping address to use at checkout.")
                            .font(AppColor.sans(14))
                            .foregroundColor(AppColor.textSec)

                        addressField(title: "Full name", text: $viewModel.fullName)
                        addressField(title: "Street address", text: $viewModel.streetAddress)
                        addressField(title: "City", text: $viewModel.city)

                        HStack(spacing: 12) {
                            addressField(title: "State", text: $viewModel.state)
                            addressField(title: "ZIP", text: $viewModel.zip)
                        }

                        if case .error(let error) = viewModel.formState {
                            Text(error.errorDescription ?? "Something went wrong.")
                                .font(AppColor.sans(13))
                                .foregroundColor(.red)
                        }

                        Button {
                            Task {
                                let success = await viewModel.submitNewAddress()
                                if success { isPresented = false }
                            }
                        } label: {
                            HStack {
                                if case .loading = viewModel.formState {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Save address")
                                        .font(AppColor.sans(16, .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColor.textPrim)
                            .clipShape(Capsule())
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColor.textSec)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(AppColor.surface))
                    }
                }
            }
        }
    }

    private func addressField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppColor.sans(12, .medium))
                .foregroundColor(AppColor.textSec)
                .tracking(0.5)

            TextField("", text: text)
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textPrim)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(AppColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColor.border, lineWidth: 0.5)
                )
        }
    }
}
