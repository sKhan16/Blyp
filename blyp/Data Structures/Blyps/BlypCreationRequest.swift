//
//  BlypCreationRequest.swift
//  blyp
//
//  Created by Hayden Hong on 4/23/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation
import UIKit

struct BlypCreationRequest {
    var id: UUID = UUID()
    var name: String
    var description: String
    
    var imageUrl: String?
    var imageBlurHash: String?
    var image: UIImage?
}
