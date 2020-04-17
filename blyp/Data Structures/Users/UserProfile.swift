//
//  UserProfile.swift
//  blyp
//
//  Created by Hayden Hong on 3/12/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var blyps: [String: Blyp]
    var friends: [String]
    var legacyContact: Friend
}

struct Friend: Codable {}
