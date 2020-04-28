//
//  BlypCard.swift
//  blyp
//
//  Created by Hayden Hong on 4/26/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct BlypCard: View {
    var backgroundColor: Color? = nil
    var backgroundImage: BlypImage? = nil
    
    let blyp: Blyp
    
    init(blyp: Blyp) {
        self.blyp = blyp
        if blyp.hasImage {
            self.backgroundImage = BlypImage(blyp: blyp)
        } else {
            backgroundColor = .blypGreen
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geom in
                VStack(alignment: .leading) {
                    Spacer()
                    VStack {
                        HStack {
                            Text(self.blyp.name).font(.headline).foregroundColor(Color.white).padding(.leading, 20).padding(.top, 10)
                            Spacer()
                        }.frame(width: geom.size.width)
                        HStack {
                            Text(self.blyp.description).font(.subheadline).foregroundColor(Color.white).padding(.leading, 20).padding(.bottom, 10)
                            Spacer()
                        }.frame(width: geom.size.width)
                    }.background(Blur(style: .systemMaterialDark))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 250)
        .background(backgroundColor)
        .background(backgroundImage)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        
    }
}

struct BlypCard_Previews: PreviewProvider {
    static var blypWithImage = BlypCard(blyp: Blyp(name: "Look at this test blyp", description: "Uhhh"))
    
    static var previews: some View {
        Group {
            blypWithImage
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
