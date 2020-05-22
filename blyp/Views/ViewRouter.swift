//
//  ViewRouter.swift
//  
//
//  Created by Shakeel Khan on 5/17/20.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: String

    init() {

        // Shows onboarding screen ONLY on first launch of app.
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "OnboardingView"
        } else {
            currentPage = "SignUpView"
        }
    }
}
