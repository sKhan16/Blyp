//
//  SearchBar.swift
//  blyp
//
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var userSearcher: UserSearcher
    var placeholder: String = "Search"

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(placeholder, text: $userSearcher.searchQuery).foregroundColor(.primary)
                Button(action: {
                    self.userSearcher.searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(userSearcher.searchQuery == "" ? 0 : 1)
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
    @State static var userSearcher: UserSearcher = UserSearcher()
    static var previews: some View {
        SearchBar(userSearcher: userSearcher, placeholder: "Search here, you nerd")
    }
}
