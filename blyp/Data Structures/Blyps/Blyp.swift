//
//  Blyp.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation
import UIKit

struct Blyp: Identifiable, Codable {
    // MARK: Properties that are expected for the JSON
    var id: UUID = UUID()
    var name: String
    var description: String
    var createdOn: Date = Date()// Default to now
    
    var imageUrl: String?
    var imageBlurHash: String?
    var imageBlurHashWidth: CGFloat?
    var imageBlurHashHeight: CGFloat?
    
    // MARK: CodingKeys for JUST properties listed above
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdOn
        case imageUrl
        case imageBlurHash
        case imageBlurHashWidth
        case imageBlurHashHeight
    }
    
    // MARK: Properties used for saving and using Blyps
    var image: UIImage?
    var hasImage: Bool {
        get {
            return self.imageUrl != nil && self.imageBlurHash != nil && self.imageBlurHashWidth != nil && self.imageBlurHashHeight != nil
        }
    }
}
