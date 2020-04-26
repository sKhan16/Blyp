//
//  BlypImage.swift
//  blyp
//
//  Created by Hayden Hong on 4/23/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


/// A VERY unsafe view for BlypImage. ONLY use this if you're sure everything required isn't null.
struct BlypImage: View {
    let blyp: Blyp
    var body: some View {
        WebImage(url: URL(string: blyp.imageUrl!))
            .onSuccess { image, cacheType in
        }
        .resizable()
        .placeholder(Image(uiImage: UIImage(blurHash: blyp.imageBlurHash!, size: CGSize(width: blyp.imageBlurHashWidth!, height: blyp.imageBlurHashHeight!))!))
        .indicator(.activity)
        .animation(.easeInOut(duration: 0.5))
        .transition(.fade)
        .scaledToFit()
        .frame(width: 300, height: 300, alignment: .center)
    }
}

struct BlypImage_Previews: PreviewProvider {
    static var previews: some View {
        BlypImage(blyp: Blyp(id: UUID(), name: "TestBlyp", description: "Uhhh", imageUrl: "", imageBlurHash: "", imageBlurHashWidth: 32.0, imageBlurHashHeight: 32.0))
    }
}
