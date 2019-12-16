//
//  TabBarController.swift
//  Example
//
//  Created by Kang Min Ahn on 2019/12/16.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarItem = UITabBarItem(title: "SwiftUI", image: UIImage(named: "swiftui-24")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
        let swiftUIVC = UIHostingController(rootView: ExampleList())
        swiftUIVC.tabBarItem = tabBarItem

        viewControllers?.append(swiftUIVC)
    }
}
