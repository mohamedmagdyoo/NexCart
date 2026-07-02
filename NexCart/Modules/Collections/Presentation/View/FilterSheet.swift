//
//  FilterSheet.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import SwiftUI

private enum FilterSection: Hashable {
    case brand
    case price
    case type
}

struct FilterSheetView: View {
    let brands: [String]
    let types: [String]
    let priceRanges: [PriceRange]

    @Binding var selectedBrand: String
    @Binding var selectedType: String
    @Binding var selectedPriceRange: PriceRange
    @Environment(\.dismiss) private var dismiss
    @State private var draftBrand: String
    @State private var draftType: String
    @State private var draftPriceRange: PriceRange
    @State private var expandedSection: FilterSection? = .brand

    init(
        brands: [String],
        types: [String],
        priceRanges: [PriceRange],
        selectedBrand: Binding<String>,
        selectedType: Binding<String>,
        selectedPriceRange: Binding<PriceRange>
    ) {
        self.brands = brands
        self.types = types
        self.priceRanges = priceRanges
        self._selectedBrand = selectedBrand
        self._selectedType = selectedType
        self._selectedPriceRange = selectedPriceRange
        self._draftBrand = State(initialValue: selectedBrand.wrappedValue)
        self._draftType = State(initialValue: selectedType.wrappedValue)
        self._draftPriceRange = State(initialValue: selectedPriceRange.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        GridRow {
                            sectionCard(
                                section: .brand,
                                title: "Brand",
                                valueLabel: draftBrand
                            )
                            sectionCard(
                                section: .price,
                                title: "Price",
                                valueLabel: draftPriceRange.rawValue
                            )
                        }
                        GridRow {
                            sectionCard(
                                section: .type,
                                title: "Product Type",
                                valueLabel: draftType
                            )
                            .gridCellColumns(2)
                        }
                    }

                    if let expandedSection {
                        optionsPanel(for: expandedSection)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(18)
                .animation(.easeInOut(duration: 0.22), value: expandedSection)
            }
            .background(AppColor.bg.ignoresSafeArea())
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        draftBrand = "All"
                        draftType = "All"
                        draftPriceRange = .all
                    }
                    .foregroundColor(AppColor.textSec)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        selectedBrand = draftBrand
                        selectedType = draftType
                        selectedPriceRange = draftPriceRange
                        dismiss()
                    }
                    .font(AppColor.sans(16, .semibold))
                    .foregroundColor(AppColor.gold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }


    private func sectionCard(section: FilterSection, title: String, valueLabel: String) -> some View {
        let isExpanded = expandedSection == section
        let isActive = valueLabel != "All"

        return Button {
            expandedSection = isExpanded ? nil : section
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(AppColor.sans(15, .semibold))
                        .foregroundColor(AppColor.textPrim)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppColor.textSec)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }

                Text(valueLabel)
                    .font(AppColor.sans(15, isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? AppColor.gold : AppColor.textSec)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(AppColor.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isExpanded ? AppColor.gold : AppColor.border, lineWidth: isExpanded ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Options panel (shared, full width, shown below the grid)

    @ViewBuilder
    private func optionsPanel(for section: FilterSection) -> some View {
        let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

        VStack(alignment: .leading, spacing: 12) {
            switch section {
            case .brand:
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(brands, id: \.self) { option in
                        optionChip(title: option, isSelected: draftBrand == option) {
                            draftBrand = option
                        }
                    }
                }
            case .price:
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(priceRanges) { range in
                        optionChip(title: range.rawValue, isSelected: draftPriceRange == range) {
                            draftPriceRange = range
                        }
                    }
                }
            case .type:
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(types, id: \.self) { option in
                        optionChip(title: option, isSelected: draftType == option) {
                            draftType = option
                        }
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.surface)
        )
    }

    private func optionChip(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(title)
                    .font(AppColor.sans(15, isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColor.textPrim : AppColor.textSec)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 4)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColor.gold : AppColor.border)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? AppColor.gold.opacity(0.14) : AppColor.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppColor.gold : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
