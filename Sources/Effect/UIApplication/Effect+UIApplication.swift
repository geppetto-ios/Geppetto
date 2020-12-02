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
        return mapT { $0.application }
    }
    
    func alert(error: Error) -> Effect<Env, Error> {
        return application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .alert(
                style: .alert, 
                title: "Error", 
                description: error.localizedDescription, 
                buttons: [("OK", .default)]
            )
            .mapT(const(error))
    }

    func dismissTopMostViewController(animated: Bool) -> Effect<Env, UIViewController> {
        return application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .dismiss(animated: animated)
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIApplication {
    var keyWindow: Effect<Env, UIWindow?> {
        return mapT { $0.keyWindow }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIWindow {
    var rootViewController: Effect<Env, UIViewController?> {
        return mapT { $0.rootViewController }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIViewController {
    var topMost: Effect<Env, UIViewController?> {
        return mapT { UIViewController.topMost(of: $0) }
    }
    
    func alert(style: UIAlertController.Style, title: String? = nil, description: String? = nil, buttons: [(String, UIAlertAction.Style)]) -> Effect<Env, String> {
        return flatMapT { (vc: UIViewController) -> Effect<Env, String> in
            return Effect<Env, String> { (_: Env) -> Single<String> in
                return Single<String>.create { [weak vc] single in
                    let alertController = UIAlertController(title: title, message: description, preferredStyle: style)
                    let actions: [UIAlertAction] = buttons.map { buttonTitle, buttonStyle -> UIAlertAction in
                        return UIAlertAction(title: buttonTitle, style: buttonStyle, handler: { _ in
                            single(.success(buttonTitle))
                        })
                    }
                    actions.forEach(alertController.addAction)
                    vc?.present(alertController, animated: true, completion: nil)
                    return Disposables.create()
                }
            }
        }
    }

    func dismiss(animated: Bool) -> Effect<Env, UIViewController> {
        return flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            return Effect<Env, UIViewController> { (_: Env) -> Single<UIViewController> in
                return Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.dismiss(animated: animated) { single(.success(vc)) }
                    return Disposables.create()
                }
            }
        }
    }
}
