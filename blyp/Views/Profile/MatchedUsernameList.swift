//
//  MatchedUsernameList.swift
//  blyp
//
//  Created by Hayden Hong on 3/30/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct MatchedUsernameList: View {
    var usernames: [String]
    var body: some View {
        List {
            ForEach(usernames, id:\.self) {
                searchText in Text(searchText)
            }
        }
    }
}

struct MatchedUsernameList_Previews: PreviewProvider {
    static var previews: some View {
        MatchedUsernameList(usernames: ["Bob", "Sabby"])
    }
}
