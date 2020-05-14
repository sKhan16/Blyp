//
//  TableViewLine.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct TableViewLine: ViewModifier {
    var status: TableViewLineAppearance
    init(is status: TableViewLineAppearance) {
        self.status = status
    }
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                switch self.status {
                case .hidden: UITableView.appearance().separatorColor = .clear

                case .shown: UITableView.appearance().separatorColor = nil

                }
            })
            .onDisappear(perform: {
                UITableView.appearance().separatorColor = nil
            })
    }
}

enum TableViewLineAppearance {
    case hidden
    case shown
}
