//
//  BlypCard.swift
//  blyp
//
//  Created by Hayden Hong on 4/26/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import MapKit
import SwiftUI

struct BlypCard: View {
    @EnvironmentObject var user: UserObservable

    @State private var isPressed = false

    let blyp: Blyp

    var body: some View {
        GeometryReader { geometry in
        VStack {
            ZStack {
                if self.blyp.hasImage {
                    BlypImage(blyp: self.blyp).frame(width: geometry.size.width, height: geometry.size.height)
                } else if self.blyp.hasLocation {
                    StaticMap(title: self.blyp.name, subtitle: self.blyp.description, latitude: self.blyp.latitude!, longitude: self.blyp.longitude!)
                } else {
                    Rectangle().fill(Color.blypGreen).frame(width: geometry.size.width, height: 256)
                }

                VStack(alignment: .leading) {
                    Spacer()
                    VStack {
                        HStack {
                            VStack {
                                HStack {
                                    Text(self.blyp.name).font(.headline).foregroundColor(Color.white).padding(.leading).padding(.top, 10)
                                    Spacer()
                                }
                                HStack {
                                    Text(self.blyp.description).font(.subheadline).foregroundColor(Color.white).padding(.leading).padding(.bottom, 10).lineLimit(2)
                                    Spacer()
                                }
                            }
                            if self.blyp.createdBy != nil {
                                ZStack {
                                    Circle().fill(Color.blypGreen)
                                    Text(self.user.friends.first(where: { f in f.uid == self.blyp.createdBy })?.displayName?[0] ?? "")
                                        .foregroundColor(Color.black)
                                }.frame(width: 40, height: 40).padding([.trailing, .top, .bottom])
                            }
                        }
                    }.background(Blur(style: .systemThinMaterialDark))
                }
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .scaleEffect(self.isPressed ? 0.5 : 1.0)
        .animation(.easeInOut)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
    }
}

struct BlypCard_Previews: PreviewProvider {
    static var blypWithImage = BlypCard(blyp: Blyp(id: UUID(),
                                                   name: "911 GT3 RS",
                                                   description: "Such a beautiful car loook at this insanely long string lalalalalalalalal",
                                                   imageUrl: "https://firebasestorage.googleapis.com/v0/b/blyp-ae6e4.appspot.com/o/test-data%2F911.jpg?alt=media&token=f1daee29-2dd2-434d-97d4-23dc39d9a848",
                                                   imageBlurHash: "USFirmaf%M%3~1aebHxc_NWFIUt9-qM_R:t8",
                                                   imageBlurHashWidth: 42.666666666666664,
                                                   imageBlurHashHeight: 32.0))

    static var previews: some View {
        Group {
            blypWithImage
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context _: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
