//
//  FilterSheet.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import SwiftUI

struct FilterSheetView: View {
    let brands: [String]
    let types: [String]

    @Binding var selectedBrand: String
    @Binding var selectedType: String

    @Environment(\.dismiss) private var dismiss
    @State private var draftBrand: String
    @State private var draftType: String

    init(brands: [String], types: [String], selectedBrand: Binding<String>, selectedType: Binding<String>) {
        self.brands = brands
        self.types = types
        self._selectedBrand = selectedBrand
        self._selectedType = selectedType
        self._draftBrand = State(initialValue: selectedBrand.wrappedValue)
        self._draftType = State(initialValue: selectedType.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            HStack(alignment: .top, spacing: 12) {
                column(title: "Brand", options: brands, selection: $draftBrand)
                column(title: "Product Type", options: types, selection: $draftType)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .background(AppColor.bg.ignoresSafeArea())
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        draftBrand = "All"
                        draftType = "All"
                    }
                    .foregroundColor(AppColor.textSec)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        selectedBrand = draftBrand
                        selectedType = draftType
                        dismiss()
                    }
                    .font(AppColor.sans(15, .semibold))
                    .foregroundColor(AppColor.gold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func column(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppColor.sans(13, .semibold))
                .foregroundColor(AppColor.textSec)
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        optionRow(
                            title: option,
                            isSelected: selection.wrappedValue == option
                        ) {
                            selection.wrappedValue = option
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    private func optionRow(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(title)
                    .font(AppColor.sans(14, isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColor.textPrim : AppColor.textSec)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                Spacer(minLength: 4)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? AppColor.gold : AppColor.border)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColor.gold.opacity(0.12) : AppColor.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColor.gold : Color.clear, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
    }
}
