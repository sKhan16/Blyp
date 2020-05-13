//
//  CGSizeNormalizeExtension.swift
//  blyp
//
//  Created by Hayden Hong on 4/23/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import UIKit
extension CGSize {
    func scale(to scale: CGFloat) -> CGSize {
        if height < width {
            return CGSize(width: (width / height) * scale, height: 32)
        } else {
            return CGSize(width: 32, height: (height / width) * scale)
        }
    }
}
