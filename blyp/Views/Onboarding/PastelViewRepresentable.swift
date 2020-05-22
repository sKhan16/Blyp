//
//  PastelViewRepresentable.swift
//
//  Created by Hayden Hong on 4/28/20.
//  Copyright © 2020 Hayden Hong. All rights reserved.
//
import Pastel
import SwiftUI

struct PastelViewRepresentable: UIViewRepresentable {
    typealias UIViewType = PastelView

    var colors: [UIColor] = [UIColor(red: 156 / 255, green: 39 / 255, blue: 176 / 255, alpha: 1.0),
                             UIColor(red: 255 / 255, green: 64 / 255, blue: 129 / 255, alpha: 1.0),
                             UIColor(red: 123 / 255, green: 31 / 255, blue: 162 / 255, alpha: 1.0),
                             UIColor(red: 32 / 255, green: 76 / 255, blue: 255 / 255, alpha: 1.0),
                             UIColor(red: 32 / 255, green: 158 / 255, blue: 255 / 255, alpha: 1.0),
                             UIColor(red: 90 / 255, green: 120 / 255, blue: 127 / 255, alpha: 1.0),
                             UIColor(red: 58 / 255, green: 255 / 255, blue: 217 / 255, alpha: 1.0)]

    var startPastelPoint: PastelPoint = .bottomLeft
    var endPastelPoint: PastelPoint = .topRight
    var animationDuration: Double = 3.0

    func makeUIView(context _: Context) -> PastelView {
        let pastel = PastelView(frame: UIScreen.main.bounds)
        pastel.setColors(colors)
        pastel.startPastelPoint = startPastelPoint
        pastel.endPastelPoint = endPastelPoint
        pastel.animationDuration = animationDuration
        pastel.startAnimation()
        return pastel
    }

    func updateUIView(_: PastelView, context _: Context) {}
}

struct PastelViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PastelViewRepresentable()
            PastelViewRepresentable(colors: [UIColor(named: "BlypOrange")!, UIColor(named: "BlypYellow")!, UIColor(named: "BlypGreen")!], startPastelPoint: .top, endPastelPoint: .bottom)
        }
    }
}
