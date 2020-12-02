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
    
    func alert(error: Error) -> Effect<Env, Error> {
        application
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

    func presentOverTopMostViewController<P, VC>(_ type: VC.Type, environment: P.Environment, animated: Bool, withNavigation: Bool = false, presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical) -> Effect<Env, Void> where P: Program, VC: ViewController<P> {
        application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .present(type, environment: environment, animated: animated, withNavigation: withNavigation, presentationStyle: presentationStyle, transitionStyle: transitionStyle)
    }

    func dismissTopMostViewController(animated: Bool) -> Effect<Env, UIViewController> {
        application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .dismiss(animated: animated)
    }

    func pushToTopMostViewController<P, VC>(_ type: VC.Type, environment: P.Environment, animated: Bool) -> Effect<Env, UIViewController> where P: Program, VC: ViewController<P> {
        application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .push(type, environment: environment, animated: animated)
    }

    func popTopMostViewController(animated: Bool) -> Effect<Env, Void> {
        application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
            .pop(animated: animated)
    }

    func popToRootViewController(animated: Bool) -> Effect<Env, Void> {
        application
            .keyWindow.rejectNil
            .rootViewController.rejectNil
            .topMost.rejectNil
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

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UIViewController {
    var topMost: Effect<Env, UIViewController?> {
        mapT { UIViewController.topMost(of: $0) }
    }
    
    func alert(style: UIAlertController.Style, title: String? = nil, description: String? = nil, buttons: [(String, UIAlertAction.Style)]) -> Effect<Env, String> {
        flatMapT { (vc: UIViewController) -> Effect<Env, String> in
            Effect<Env, String> { (_: Env) -> Single<String> in
                Single<String>.create { [weak vc] single in
                    let alertController = UIAlertController(title: title, message: description, preferredStyle: style)
                    let actions: [UIAlertAction] = buttons.map { buttonTitle, buttonStyle -> UIAlertAction in
                        UIAlertAction(title: buttonTitle, style: buttonStyle, handler: { _ in
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

    func present<P, VC>(_ type: VC.Type, environment: P.Environment, animated: Bool, withNavigation: Bool, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) -> Effect<Env, Void> where P: Program, VC: ViewController<P> {
        flatMapT { (vc: UIViewController) -> Effect<Env, Void> in
            Effect<Env, Void> { (_: Env) -> Single<Void> in
                Single<Void>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    let target: VC = VC()
                    P.bind(with: target, environment: environment)
                    var targetToPresent: UIViewController
                    if withNavigation {
                        targetToPresent = UINavigationController(rootViewController: target)
                    } else {
                        targetToPresent = target
                    }
                    targetToPresent.modalPresentationStyle = presentationStyle
                    targetToPresent.modalTransitionStyle = transitionStyle
                    vc.present(targetToPresent, animated: animated) {
                        single(.success(()))
                    }
                    return Disposables.create()
                }
            }
        }
    }

    func dismiss(animated: Bool) -> Effect<Env, UIViewController> {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (_: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.dismiss(animated: animated) { single(.success(vc)) }
                    return Disposables.create()
                }
            }
        }
    }

    func push<P, VC>(_ type: VC.Type, environment: P.Environment, animated: Bool) -> Effect<Env, UIViewController> where P: Program, VC: ViewController<P> {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (_: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    let targetToPush: VC = VC()
                    P.bind(with: targetToPush, environment: environment)
                    vc.navigationController?.pushViewController(targetToPush, animated: animated)
                    single(.success(targetToPush))
                    return Disposables.create()
                }
            }
        }
    }

    func pop(animated: Bool) -> Effect<Env, Void> {
        flatMapT { (vc: UIViewController) -> Effect<Env, Void> in
            Effect<Env, Void> { (_: Env) -> Single<Void> in
                Single<Void>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.navigationController?.popViewController(animated: animated)
                    single(.success(()))
                    return Disposables.create()
                }
            }
        }
    }

    func popToRoot(animated: Bool) -> Effect<Env, Void> {
        flatMapT { (vc: UIViewController) -> Effect<Env, Void> in
            Effect<Env, Void> { (_: Env) -> Single<Void> in
                Single<Void>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.navigationController?.popToRootViewController(animated: animated)
                    single(.success(()))
                    return Disposables.create()
                }
            }
        }
    }
}
