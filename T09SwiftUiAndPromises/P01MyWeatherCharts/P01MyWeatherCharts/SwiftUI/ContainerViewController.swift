//
//  ContainerViewController.swift
//  SwiftUIDemo
//
//  Created by Georgi Manev on 30.01.23.
//

import UIKit
import SwiftUI


class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appearanceMode = LocalDataManager.appearanceMode {
        
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            switch appearanceMode {
            case .system:
                window?.overrideUserInterfaceStyle = .unspecified
            case .dark:
                window?.overrideUserInterfaceStyle = .dark
            case .light:
                window?.overrideUserInterfaceStyle = .light
            }
        }
        
        let weatherDataView = SwiftUIView()
        let hostingController = UIHostingController(rootView: weatherDataView)
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
