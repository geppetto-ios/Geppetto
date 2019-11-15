//
//  UIViewController+Geppetto.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 15/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        var topMostViewController: UIViewController = self
        while let presented = topMostViewController.presentedViewController {
            topMostViewController = presented
        }
        
        return topMostViewController
    }
    
    func findPresentingViewController<T: UIViewController>(of type: T.Type) -> T? {
        var maybeMatchedViewController: UIViewController? = self
        while maybeMatchedViewController != nil {
            if let matched = maybeMatchedViewController as? T {
                return matched
            }
            maybeMatchedViewController = maybeMatchedViewController?.presentingViewController
        }
        return nil
    }
    
    var rootPresentingViewController: UIViewController? {
        var maybeTopViewController = self.presentingViewController
        while let parent = maybeTopViewController?.presentingViewController {
            maybeTopViewController = parent
        }
        return maybeTopViewController
    }
    
    static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
