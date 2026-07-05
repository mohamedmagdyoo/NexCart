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
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.93, blue: 0.87)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("New address")
                            .font(.system(.largeTitle, design: .serif))

                        Text("Add a shipping address to use at checkout.")
                            .foregroundColor(.secondary)

                        AddressFieldView(title: "Full name", text: $viewModel.fullName)
                        AddressFieldView(title: "Street address", text: $viewModel.streetAddress)
                        AddressFieldView(title: "City", text: $viewModel.city)

                        HStack(spacing: 12) {
                            AddressFieldView(title: "State", text: $viewModel.state)
                            AddressFieldView(title: "ZIP", text: $viewModel.zip)
                        }

                        if case .error(let error) = viewModel.formState {
                            Text(error.errorDescription ?? "Something went wrong.")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        Button {
                            Task {
                                let success = await viewModel.submitNewAddress()
                                if success {
                                    isPresented = false
                                }
                            }
                        } label: {
                            HStack {
                                if case .loading = viewModel.formState {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Save address")
                                }
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct AddressFieldView: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .clipShape(Capsule())
        }
    }
}
