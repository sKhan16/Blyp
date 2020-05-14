//
//  BlypImage.swift
//  blyp
//
//  Created by Hayden Hong on 4/23/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

/// A VERY unsafe view for BlypImage. ONLY use this if you're sure everything required isn't null.
struct BlypImage: View {
    var blyp: Blyp
    var contentMode: ContentMode?
    var body: some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: self.blyp.imageUrl!))
                .onSuccess { _, _ in
            }
            .resizable()
            .placeholder(Image(uiImage: UIImage(blurHash: self.blyp.imageBlurHash!, size: CGSize(width: self.blyp.imageBlurHashWidth!, height: self.blyp.imageBlurHashHeight!))!))
            .scaledToFit()
            .aspectRatio(contentMode: self.contentMode != nil ? self.contentMode! : .fill)
            .frame(width: geometry.size.width, height: geometry.size.height,  alignment: .center)
        }
    }
}

struct BlypImage_Previews: PreviewProvider {
    static var previews: some View {
        BlypImage(blyp: Blyp(id: UUID(), name: "TestBlyp", description: "Uhhh", imageUrl: "", imageBlurHash: "", imageBlurHashWidth: 32.0, imageBlurHashHeight: 32.0))
    }
}
