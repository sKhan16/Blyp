//
//  Blyp.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation
import UIKit

struct Blyp: Identifiable, Codable, Comparable {
    // MARK: Properties that are expected for the JSON

    var id: UUID = UUID()
    var name: String
    var description: String
    var createdOn: Date = Date() // Default to now
    var createdBy: String? // UUID

    var imageUrl: String?
    var imageBlurHash: String?
    var imageBlurHashWidth: CGFloat?
    var imageBlurHashHeight: CGFloat?

    var longitude: Double?
    var latitude: Double?
    var hasLocation: Bool {
        return longitude != nil && latitude != nil
    }

    var trigger: Trigger?
    
    // MARK: CodingKeys for JUST properties listed above

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdOn
        case createdBy
        case imageUrl
        case imageBlurHash
        case imageBlurHashWidth
        case imageBlurHashHeight
        case longitude
        case latitude
        case trigger
    }

    // MARK: Properties used for saving and using Blyps

    var image: UIImage?
    var hasImage: Bool {
        return imageUrl != nil && imageBlurHash != nil && imageBlurHashWidth != nil && imageBlurHashHeight != nil
    }

    // MARK: Make sure sortable by date in reverse chronological order

    static func < (lhs: Blyp, rhs: Blyp) -> Bool {
        lhs.createdOn > rhs.createdOn
    }
}

enum Trigger: String, Codable {
    case immediate = "Immediately"
    case delayed = "On a future date"
    case uponDeceased = "When I have passed away"
}
