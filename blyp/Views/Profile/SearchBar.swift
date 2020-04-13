//
//  SearchBar.swift
//  blyp
//
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search"
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(placeholder, text: $searchText, onEditingChanged: { isEditing in
                    // ?
                }, onCommit: {
                    // ?
                    }).foregroundColor(.primary)
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        SearchBar(searchText: $text, placeholder: "Search here, you nerd")
    }
}
