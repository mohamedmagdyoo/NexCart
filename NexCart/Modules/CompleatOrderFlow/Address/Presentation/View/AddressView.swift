//
//  AddressView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressViewModel
    let ownerUserId: String
    @State private var showingAddAddress = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            AppColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Shipping Addresses")
                            .font(AppColor.serif(28, .medium))
                            .foregroundColor(AppColor.textPrim)
                        Spacer()
                    }
                    .padding(.top, 12)

                    switch viewModel.listState {
                    case .idle, .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)

                    case .empty:
                        VStack(spacing: 12) {
                            Image(systemName: "mappin.slash")
                                .font(.system(size: 36, weight: .light))
                                .foregroundColor(AppColor.textSec.opacity(0.5))
                            Text("No saved addresses yet.")
                                .font(AppColor.sans(15))
                                .foregroundColor(AppColor.textSec)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)

                    case .success(let addresses):
                        ForEach(addresses) { address in
                            AddressCardView(
                                address: address,
                                onSetDefault: {
                                    Task { await viewModel.setDefault(address) }
                                },
                                onDelete: {
                                    Task { await viewModel.delete(address) }
                                }
                            )
                        }

                    case .error(let error):
                        Text(error.errorDescription ?? "Something went wrong.")
                            .font(AppColor.sans(14))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    }

                    Button {
                        showingAddAddress = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add new address")
                                .font(AppColor.sans(16, .semibold))
                        }
                        .foregroundColor(AppColor.card)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColor.textPrim)
                        .clipShape(Capsule())
                    }
                    .padding(.top, 12)

                    Color.clear.frame(height: 80)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .goldBackButton()
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showingAddAddress) {
            AddNewAddressView(viewModel: viewModel, isPresented: $showingAddAddress)
        }
        .task {
            await viewModel.loadAddresses()
        }
    }
}

struct AddressCardView: View {
    let address: AddressEntity
    let onSetDefault: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(address.displayName)
                    .font(.headline)
                Spacer()
            }

            Text(address.streetAddress)
                .foregroundColor(.secondary)
            Text(address.cityStateZipLine)
                .foregroundColor(.secondary)

            HStack {
                if address.isDefault {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                        Text("Default")
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColor.gold.opacity(0.12))
                    .foregroundColor(AppColor.gold)
                    .clipShape(Capsule())

                    Spacer()

                    Text("SELECTED")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Button(action: onSetDefault) {
                        Text("Set as default")
                            .font(AppColor.sans(13, .medium))
                            .foregroundColor(AppColor.textPrim)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(AppColor.surface)
                            .clipShape(Capsule())
                            .overlay(
                            Capsule().stroke(AppColor.border, lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(address.isDefault ? AppColor.gold.opacity(0.6): AppColor.border, lineWidth: 2)
        )
    }
}
