//
//  Error.swift
//  Geppetto
//
//  Created by Riiid_Pilgwon on 11/06/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation

typealias GPTResult<T> = Result<T, GPTError>

enum GPTError: Error {
    case custom(String)
    case underlying(Error)
}

extension GPTError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .custom(x):
            return x
        case let .underlying(error):
            return error.localizedDescription
        }
    }
}
