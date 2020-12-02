//
//  Effect+UIViewController.swift
//  Geppetto
//
//  Created by jinseo on 2020/12/02.
//  Copyright © 2020 rinndash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    func present<P, VC>(_ type: VC.Type, animated: Bool, withNavigation: Bool = false, presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical) -> Effect<Env, UIViewController> where P: Program, VC: ViewController<P>, P.Environment == Env {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (env: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    let target: VC = VC()
                    P.bind(with: target, environment: env)
                    var targetToPresent: UIViewController
                    if withNavigation {
                        targetToPresent = UINavigationController(rootViewController: target)
                    } else {
                        targetToPresent = target
                    }
                    targetToPresent.modalPresentationStyle = presentationStyle
                    targetToPresent.modalTransitionStyle = transitionStyle
                    vc.present(targetToPresent, animated: animated) {
                        single(.success(targetToPresent))
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

    func push<P, VC>(_ type: VC.Type, animated: Bool) -> Effect<Env, UIViewController> where P: Program, VC: ViewController<P>, P.Environment == Env {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (env: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    let targetToPush: VC = VC()
                    P.bind(with: targetToPush, environment: env)
                    vc.navigationController?.pushViewController(targetToPush, animated: animated)
                    single(.success(targetToPush))
                    return Disposables.create()
                }
            }
        }
    }

    func pop(animated: Bool) -> Effect<Env, UIViewController> {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (_: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.navigationController?.popViewController(animated: animated)
                    single(.success(vc))
                    return Disposables.create()
                }
            }
        }
    }

    func popToRoot(animated: Bool) -> Effect<Env, UIViewController> {
        flatMapT { (vc: UIViewController) -> Effect<Env, UIViewController> in
            Effect<Env, UIViewController> { (_: Env) -> Single<UIViewController> in
                Single<UIViewController>.create { [weak vc] single in
                    guard let vc = vc else { return Disposables.create() }
                    vc.navigationController?.popToRootViewController(animated: animated)
                    single(.success(vc))
                    return Disposables.create()
                }
            }
        }
    }
}
