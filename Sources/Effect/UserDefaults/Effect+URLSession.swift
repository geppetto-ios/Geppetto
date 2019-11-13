//
//  Effect+URLSession.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 13/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public protocol HasURLSession {
    var urlSession: URLSession { get }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element: HasURLSession {
    var urlSession: Reader<Env, Single<URLSession>> {
        return mapT { $0.urlSession }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == UserDefaults {
    
}
