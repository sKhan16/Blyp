//
//  BlypCard.swift
//  blyp
//
//  Created by Hayden Hong on 4/26/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import MapKit

struct BlypCard: View {
    private var backgroundColor: Color? = nil
    private var backgroundImage: BlypImage? = nil
    private var backgroundMap: StaticMap? = nil
    
    @State private var isPressed = false
    @State private var isShowingMap = false
    @State private var isFirstSwitchRequest = true
    
    let blyp: Blyp
    
    init(blyp: Blyp) {
        self.blyp = blyp
        if blyp.hasImage {
            backgroundImage = BlypImage(blyp: blyp, height: 250)
        }
        
        if blyp.hasLocation {
            guard let latitude = blyp.latitude else {
                setBackupStyle()
                return
            }
            guard let longitude = blyp.longitude else {
                setBackupStyle()
                return
            }
            backgroundMap = StaticMap(title: blyp.name, subtitle: blyp.description, latitude: latitude, longitude: longitude)
        } else {
            setBackupStyle()
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geom in
                ZStack {
                    // Show background image, background map, or fade between both
                    if self.blyp.hasImage && !self.blyp.hasLocation {
                        self.backgroundImage
                    } else if self.blyp.hasLocation && !self.blyp.hasImage {
                        self.backgroundMap
                    } else if self.blyp.hasLocation && self.blyp.hasImage {
                        // Ternary doesn't work here :(
                        if (self.isShowingMap) {
                            self.backgroundMap.onAppear(perform: self.updateMapImageSwitch)
                        } else {
                            self.backgroundImage.onAppear(perform: self.updateMapImageSwitch)
                        }
                    } else {
                        self.backgroundColor
                    }
                    
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
        }
        .frame(height: 250)
        .background(backgroundColor)
        .scaleEffect(isPressed ? 0.5 : 1.0)
        .animation(.easeInOut)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
    
    mutating func setBackupStyle() {
        backgroundColor = .blypGreen
    }
    
    private func updateMapImageSwitch() {
        // We have to wait for the image to load, this function gets called multiple times at launch due to loading animation
        if (isFirstSwitchRequest) {
            print("Gotcha! Image sent two requests and I ignored the first one")
            isFirstSwitchRequest = false
            return
        }
        withAnimation(.spring()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                print("Switchin' it up on blyp \(self.blyp.id)")
                self.isShowingMap.toggle()
            })
        }
    }
}

struct BlypCard_Previews: PreviewProvider {
    static var blypWithImage = BlypCard(blyp: Blyp(id: UUID(), name: "911 GT3 RS", description: "Such a beautiful car", imageUrl: "https://firebasestorage.googleapis.com/v0/b/blyp-ae6e4.appspot.com/o/test-data%2F911.jpg?alt=media&token=f1daee29-2dd2-434d-97d4-23dc39d9a848", imageBlurHash: "USFirmaf%M%3~1aebHxc_NWFIUt9-qM_R:t8", imageBlurHashWidth: 42.666666666666664, imageBlurHashHeight: 32.0))
    
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
