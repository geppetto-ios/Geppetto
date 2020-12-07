//
//  BeginnerProgram.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 07/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public protocol BeginnerProgram: IndependentProgram, StateMachine { }

public extension BeginnerProgram {
    static func bind<V>(with view: V) where V: View, V.Model == ViewModel, V.Message == Message {
        bind(with: view, dependency: Unit(), environment: Unit())
    }
}
