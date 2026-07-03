//
//  AddressView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//


import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressViewModel
    @State private var showingAddAddress = false
    let ownerUserId: String

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.93, blue: 0.87)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Saved addresses")
                                .font(.system(.title2, design: .serif))
                        }
                        .padding(.top, 12)

                        switch viewModel.listState {
                        case .idle, .loading:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)

                        case .empty:
                            Text("No saved addresses yet.")
                                .foregroundColor(.secondary)
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
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.15, green: 0.08, blue: 0.06))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .padding(.top, 12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Addresses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .sheet(isPresented: $showingAddAddress) {
                AddNewAddressView(viewModel: viewModel, ownerUserId: ownerUserId, isPresented: $showingAddAddress)
            }
            .task {
                await viewModel.loadAddresses()
            }
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
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                }
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
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer()

                    Text("SELECTED")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Button(action: onSetDefault) {
                        Text("Set as default")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .overlay(
                                Capsule().stroke(Color.secondary, lineWidth: 1)
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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(address.isDefault ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}
