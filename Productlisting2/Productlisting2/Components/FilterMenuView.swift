//
//  FilterMenuView.swift
//  ShopApp
//
import SwiftUI

struct FilterMenuView: View {
    let options: [ProductListViewModel.FilterOption]
    @Binding var selectedFilter: ProductListViewModel.FilterOption

    var body: some View {
        Menu {
            ForEach(options) { option in
                Button {
                    selectedFilter = option
                } label: {
                    if selectedFilter == option {
                        Label(option.title, systemImage: "checkmark")
                    } else {
                        Text(option.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text(selectedFilter.title)
                    .lineLimit(1)
            }
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.orange.opacity(0.15))
            .foregroundColor(.orange)
            .clipShape(Capsule())
        }
    }
}
