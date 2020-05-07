//
//  FriendProfile.swift
//  blyp
//
//  Created by Hayden Hong on 4/16/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation

struct FriendProfile: Equatable {
    var displayName: String?
    var uid: String

    // UID is the only thing we really care about
    static func == (lhs: FriendProfile, rhs: FriendProfile) -> Bool {
        return lhs.uid == rhs.uid
    }
}

