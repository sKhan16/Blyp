//
//  FriendProfile.swift
//  blyp
//
//  Created by Hayden Hong on 4/16/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation

struct FriendProfile: Decodable, Equatable, Identifiable, Comparable {
    var id: String { return uid }
    var uid: String
    var displayName: String?
    var legacyContact: String?
    var deceased: Bool?

    enum CodingKeys: String, CodingKey {
        case uid = "objectID"
        case displayName
        case legacyContact
        case deceased
    }

    func isAlreadyFriend(of user: UserObservable) -> Bool {
        return user.friends.contains(self)
    }

    func isLegacyContact(of user: UserObservable) -> Bool {
        return user.legacyContact == uid
    }

    func isUsersLegacyContact(user: UserObservable) -> Bool {
        return user.legacyContact == uid
    }

    func isDeceased(using user: UserObservable) -> Bool {
        // We have to check live since these don't update too quickly
        return user.friends.contains(where: { $0.deceased ?? false && $0.uid == self.uid })
    }

    // UID is the only thing we really care about
    static func == (lhs: FriendProfile, rhs: FriendProfile) -> Bool {
        return lhs.uid == rhs.uid
    }

    // Alphabetical O(nlogn)
    static func < (lhs: FriendProfile, rhs: FriendProfile) -> Bool {
        return lhs.displayName ?? "" < rhs.displayName ?? ""
    }
}
