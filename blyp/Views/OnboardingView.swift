//
//  OnboardingView.swift
//  blyp
//
//  Created by Shakeel Khan on 5/1/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    //Place to add images if desired.
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "imageName1")),
        UIHostingController(rootView: Subview(imageString: "imageName2")),
        UIHostingController(rootView: Subview(imageString: "imageName3"))
    ]
    
    var titles = ["Create and share Blyps!", "Appoint a legacy contact", "Automatic posting"]
    
    var captions =  ["Blyps are digital memories of any media: photos, videos, or just text that you can share with your loved ones!", "Legacy contacts are specially appointed by you to look after your account after your passing", "Select a future date or after your passing and your Blyp will be posted for you at that time!"]
    
    @State private var currentPageIndex = 0
    
    var body: some View {
        VStack(alignment: .center) {
            PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                .frame(height: 600)
            Group {
                Text(titles[currentPageIndex])
                    .font(.title)
                Text(captions[currentPageIndex])
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 350, height: 100, alignment: .leading)
                .lineLimit(nil)
            }
                //.padding()
            VStack(alignment: .center) {
                PageControl(numberOfPages: titles.count, currentPageIndex: $currentPageIndex)
                Spacer()
                /* uncomment for next button
                 Button(action: {
                    if self.currentPageIndex+1 == self.subviews.count {
                        self.currentPageIndex = 0
                    } else {
                        self.currentPageIndex += 1
                    }
                }) {
                    ButtonContent()
                }*/
            }
                .padding()
        }
    }
}

/* Uncomment for next button
 struct ButtonContent: View {
    var body: some View {
        Image(systemName: "arrow.right")
        .resizable()
        .foregroundColor(.white)
        .frame(width: 30, height: 30)
        .padding()
        .background(Color.orange)
        .cornerRadius(30)
    }
}*/

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
#endif