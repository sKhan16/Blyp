//
//  PageViewController.swift
//  blyp
//
//  Created by Shakeel Khan on 4/24/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//


import SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[0]], direction: .forward, animated: true)
    }
}
