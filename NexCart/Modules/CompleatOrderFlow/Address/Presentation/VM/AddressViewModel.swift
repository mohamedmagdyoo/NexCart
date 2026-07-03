//
//  AddressViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation
import Combine


enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case empty
    case error(AddressError)
}

@MainActor
final class AddressViewModel: ObservableObject {
    @Published private(set) var listState: ViewState<[AddressEntity]> = .idle
    @Published private(set) var formState: ViewState<AddressEntity> = .idle

    @Published var fullName = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zip = ""
    @Published var label = ""

    private let addAddressUseCase: AddAddressUseCase
    private let deleteAddressUseCase: DeleteAddressUseCase
    private let deleteAllAddressesUseCase: DeleteAllAddressesUseCase
    private let getAllAddressesUseCase: GetAllAddressesUseCase
    private let getDefaultAddressUseCase: GetDefaultAddressUseCase

    init(
        addAddressUseCase: AddAddressUseCase,
        deleteAddressUseCase: DeleteAddressUseCase,
        deleteAllAddressesUseCase: DeleteAllAddressesUseCase,
        getAllAddressesUseCase: GetAllAddressesUseCase,
        getDefaultAddressUseCase: GetDefaultAddressUseCase
    ) {
        self.addAddressUseCase = addAddressUseCase
        self.deleteAddressUseCase = deleteAddressUseCase
        self.deleteAllAddressesUseCase = deleteAllAddressesUseCase
        self.getAllAddressesUseCase = getAllAddressesUseCase
        self.getDefaultAddressUseCase = getDefaultAddressUseCase
    }

    func loadAddresses() async {
        listState = .loading
        do {
            let addresses = try await getAllAddressesUseCase.execute()
            listState = addresses.isEmpty ? .empty : .success(addresses)
        } catch let error as AddressError {
            listState = .error(error)
        } catch {
            listState = .error(.unknown(underlying: error.localizedDescription))
        }
    }


    func submitNewAddress(ownerUserId: String) async -> Bool {
        formState = .loading

        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            formState = .error(.invalidAddress(field: "Full name"))
            return false
        }
        guard !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty else {
            formState = .error(.invalidAddress(field: "Street address"))
            return false
        }
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            formState = .error(.invalidAddress(field: "City"))
            return false
        }
        guard !state.trimmingCharacters(in: .whitespaces).isEmpty else {
            formState = .error(.invalidAddress(field: "State"))
            return false
        }
        guard !zip.trimmingCharacters(in: .whitespaces).isEmpty else {
            formState = .error(.invalidAddress(field: "ZIP"))
            return false
        }

        let newAddress = AddressEntity(
            fullName: fullName,
            streetAddress: streetAddress,
            city: city,
            state: state,
            zip: zip,
            label: label.isEmpty ? nil : label,
            isDefault: false,
            ownerUserId: ownerUserId
        )

        do {
            try await addAddressUseCase.execute(newAddress)
            formState = .success(newAddress)
            clearForm()
            await loadAddresses()
            return true
        } catch let error as AddressError {
            formState = .error(error)
            return false
        } catch {
            formState = .error(.unknown(underlying: error.localizedDescription))
            return false
        }
    }

    func delete(_ address: AddressEntity) async {
        do {
            try await deleteAddressUseCase.execute(id: address.id)
            await loadAddresses()
        } catch let error as AddressError {
            listState = .error(error)
        } catch {
            listState = .error(.unknown(underlying: error.localizedDescription))
        }
    }

    func deleteAll() async {
        do {
            try await deleteAllAddressesUseCase.execute()
            await loadAddresses()
        } catch let error as AddressError {
            listState = .error(error)
        } catch {
            listState = .error(.unknown(underlying: error.localizedDescription))
        }
    }

    func setDefault(_ address: AddressEntity) async {
        guard case .success(let currentAddresses) = listState else { return }

        do {
            for existing in currentAddresses where existing.isDefault && existing.id != address.id {
                try await deleteAddressUseCase.execute(id: existing.id)
                var demoted = existing
                demoted.isDefault = false
                try await addAddressUseCase.execute(demoted)
            }

            try await deleteAddressUseCase.execute(id: address.id)
            var promoted = address
            promoted.isDefault = true
            try await addAddressUseCase.execute(promoted)

            await loadAddresses()
        } catch let error as AddressError {
            listState = .error(error)
        } catch {
            listState = .error(.unknown(underlying: error.localizedDescription))
        }
    }

    func clearForm() {
        fullName = ""
        streetAddress = ""
        city = ""
        state = ""
        zip = ""
        label = ""
        formState = .idle
    }
}
