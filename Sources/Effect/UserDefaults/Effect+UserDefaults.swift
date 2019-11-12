//
//  Effect+UserDefaults.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 11/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public enum UserDefaultsEffectEffor: Error {
    case valueIsUnexpectedType(value: String, type: String)
}

public protocol HasUserDefaults {
    var userDefaults: UserDefaults { get }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element: HasUserDefaults {
    var userDefaults: Reader<Env, Single<UserDefaults>> {
        return mapT { $0.userDefaults }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UserDefaults {
    func value(for key: String) -> Reader<Env, Single<Any?>> {
        return flatMapT { (userDefaults: UserDefaults) in
            return Reader<Env, Single<Any?>> { [unowned userDefaults] _ in
                return Single.create { single in                
                    single(.success(userDefaults.value(forKey: key)))
                    return Disposables.create()
                }
            }
        }  
    }
    
    func value<T>(for key: String, of type: T.Type) -> Reader<Env, Single<T?>> {
        return value(for: key)
            .flatMapT { (any: Any?) -> Reader<Env, Single<T?>> in
                switch any {
                case let .some(x):
                    return (x as? T).fold(
                        onSome: { x in Reader<Env, Single<T?>> { _ in Single.just(x) } }, 
                        onNone: Reader<Env, Single<T?>> { _ in
                            return Single.error(UserDefaultsEffectEffor.valueIsUnexpectedType(value: "\(x)", type: "\(type)")) 
                        }
                    )
                case .none:
                    return Reader<Env, Single<T?>> { _ in Single.just(nil) }
                }
        }  
    }
    
    func setValue<T>(_ value: T?, for key: String) -> Reader<Env, Single<T?>> {
        return flatMapT { (userDefaults: UserDefaults) in
            return Reader<Env, Single<T?>> { [unowned userDefaults] _ in
                return Single.create { single in
                    userDefaults.set(value, forKey: key)
                    single(.success(value))
                    return Disposables.create()
                }
            }
        }
    }
    
    func removeValue(for key: String) -> Reader<Env, Single<String>> {
        return flatMapT { (userDefaults: UserDefaults) in
            Reader<Env, Single<String>> { [unowned userDefaults] _ in
                return Single.create { single in
                    userDefaults.set(nil, forKey: key)
                    single(.success(key))
                    return Disposables.create()
                }
            }
        }
    }
    
    func synchronize() -> Reader<Env, Single<Bool>> {
        return flatMapT { (userDefaults: UserDefaults) in
            return Reader<Env, Single<Bool>> { [unowned userDefaults] _ in
                return Single.create { single in
                    single(.success(userDefaults.synchronize()))
                    return Disposables.create()
                }
            }
        }
    }
}
