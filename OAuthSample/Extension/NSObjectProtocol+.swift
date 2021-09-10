//
//  NSObjectProtocol+.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/10.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        String(describing: self)
    }
}
