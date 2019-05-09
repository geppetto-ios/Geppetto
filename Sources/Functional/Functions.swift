//
//  Identity.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

public func id<T>(_ x: T) -> T {
    return x
}

public func const<T, C>(_ x: C) -> (T) -> C {
    return { _ in x }
}
