//
//  NewBlypView.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct BlypView: View {
    @EnvironmentObject var user: UserObservable
    @State var blyp: Blyp
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if self.blyp.hasImage {
                    BlypImage(blyp: self.blyp,contentMode: .fit)
                        .edgesIgnoringSafeArea(.all).frame(maxWidth: geometry.size.width)
                }
                Text(self.self.blyp.name).font(.largeTitle).padding([.top, .horizontal])
                if self.blyp.createdBy != nil {
                    Text(self.user.friends.first(where: { f in f.uid == self.blyp.createdBy })?.displayName ?? "")
                        .font(.subheadline)
                }
                Text(self.self.blyp.description).multilineTextAlignment(.leading).padding().lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                if self.blyp.hasLocation {
                    StaticMap(title: self.blyp.name, subtitle: self.blyp.description, latitude: self.blyp.latitude ?? 0, longitude: self.blyp.longitude ?? 0, isScrollable: true)
                        .frame(height: 500)
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct NewBlypView_Previews: PreviewProvider {
    static var copyPasta = """
    Gentlemen, a short view back to the past. Thirty years ago, Niki Lauda told us ‘take a monkey, place him into the cockpit and he is able to drive the car.’ Thirty years later, Sebastian told us ‘I had to start my car like a computer, it’s very complicated.’ And Nico Rosberg said that during the race – I don’t remember what race - he pressed the wrong button on the wheel. Question for you both: is Formula One driving today too complicated with twenty and more buttons on the wheel, are you too much under effort, under pressure? What are your wishes for the future concerning the technical programme during the race? Less buttons, more? Or less and more communication with your engineers?
    """
    static var previews: some View {
        Group {
            // Blyp with just text
            BlypView(blyp: Blyp(name: "Grazie Vettel 🏎", description: copyPasta)) // .previewLayout(.sizeThatFits)
            
            // Blyp with image and location
            BlypView(blyp: Blyp(id: UUID(), name: "Grazie Vettel 🏎", description: copyPasta, createdOn: Date(), imageUrl: "https://firebasestorage.googleapis.com/v0/b/blyp-ae6e4.appspot.com/o/QQzrVomYKhQEIQJdKmXne9JdQKC2%2FBD895A77-3B14-45E6-A71E-F44C667D2740.jpeg?alt=media&token=a478b704-36df-4daf-9494-fd01daf4d828", imageBlurHash: "UWECReM{tRj@~CWBWojZ$*kCWBaynmkCjafR", imageBlurHashWidth: 56.8421052631579, imageBlurHashHeight: 32.0, longitude: 9.722223645836072, latitude: 50.514466054613855)) // .previewLayout(.sizeThatFits)
            
            // Blyp with just image
            BlypView(blyp: Blyp(id: UUID(), name: "Grazie Vettel 🏎", description: copyPasta, createdOn: Date(), imageUrl: "https://firebasestorage.googleapis.com/v0/b/blyp-ae6e4.appspot.com/o/QQzrVomYKhQEIQJdKmXne9JdQKC2%2FBD895A77-3B14-45E6-A71E-F44C667D2740.jpeg?alt=media&token=a478b704-36df-4daf-9494-fd01daf4d828", imageBlurHash: "UWECReM{tRj@~CWBWojZ$*kCWBaynmkCjafR", imageBlurHashWidth: 56.8421052631579, imageBlurHashHeight: 32.0)) // .previewLayout(.sizeThatFits)
            // Blyp with just location
            BlypView(blyp: Blyp(id: UUID(), name: "Grazie Vettel 🏎", description: copyPasta, createdOn: Date(), longitude: 9.722223645836072, latitude: 50.514466054613855)) // .previewLayout(.sizeThatFits)
        }
    }
}
