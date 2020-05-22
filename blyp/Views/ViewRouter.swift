//
//  ViewRouter.swift
//  
//
//  Created by Shakeel Khan on 5/17/20.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    
    init() {
        
        // Shows onboarding screen ONLY on first launch of app.
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "OnboardingView"
        } else {
            currentPage = "MainView"
        }
    }
    
    @Published var currentPage: String
    
}
