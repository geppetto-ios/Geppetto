//
//  Effect+UIWindow.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 15/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol HasUIApplication {
    var application: UIApplication { get }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element: HasUIApplication {
    var application: Effect<Env, UIApplication> {
        mapT { $0.application }
    }

    var topMostViewController: Effect<Env, UIViewController> {
      application
        .keyWindow.rejectNil
        .rootViewController.rejectNil
        .topMost.rejectNil
    }
    
    func alert(error: Error) -> Effect<Env, Error> {
        topMostViewController
            .alert(
                style: .alert, 
                title: "Error", 
                description: error.localizedDescription, 
                buttons: [("OK", .default)]
            )
            .mapT(const(error))
    }

    func popToRootViewController(animated: Bool) -> Effect<Env, UIViewController> {
        topMostViewController
            .popToRoot(animated: animated)
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIApplication {
    var keyWindow: Effect<Env, UIWindow?> {
        mapT { $0.keyWindow }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIWindow {
    var rootViewController: Effect<Env, UIViewController?> {
        mapT { $0.rootViewController }
    }
}
