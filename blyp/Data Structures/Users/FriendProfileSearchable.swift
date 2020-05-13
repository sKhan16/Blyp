//
//  FriendProfile.swift
//  blyp
//
//  Created by Hayden Hong on 4/16/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation

struct FriendProfileSearchable: Decodable, Equatable, Identifiable {
    var id = UUID()
    var displayName: String?
    var uid: String
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case uid = "objectID"
    }

    func isAlreadyFriend(of user: UserObservable) -> Bool {
        return user.friends.contains(self)
    }

    func isLegacyContact(of user: UserObservable) -> Bool {
        return user.legacyContact == uid
    }

    // UID is the only thing we really care about
    static func == (lhs: FriendProfileSearchable, rhs: FriendProfileSearchable) -> Bool {
        return lhs.uid == rhs.uid
    }
}
