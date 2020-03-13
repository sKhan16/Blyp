//
//  Blyp.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation
struct Blyp: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var image: String?
}
