//
//  UserDefaults+.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/10.
//

import Foundation

enum UserDefaultsKey: String {
    case qiitaAccessTokenKey
}

extension UserDefaults {
    var qiitaAccessToken: String {
        get {
            self.string(forKey: UserDefaultsKey.qiitaAccessTokenKey.rawValue) ?? ""
        }
        set {
            self.setValue(newValue, forKey: UserDefaultsKey.qiitaAccessTokenKey.rawValue)
        }
    }
}
