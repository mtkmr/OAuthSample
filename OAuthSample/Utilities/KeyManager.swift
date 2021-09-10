//
//  KeyManager.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/09.
//

import Foundation

final class KeyManager {
    static let shared = KeyManager()
    private init() {}

    private let keyFilePath = Bundle.main.path(forResource: "ClientKey", ofType: "plist")

    // apiKey.plistのキーの辞書を取得
    private func getKeys() -> [String: AnyObject]? {
        guard let keyFilePath = keyFilePath else { return nil }
        return NSDictionary(contentsOfFile: keyFilePath) as? [String: AnyObject]
    }

    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else { return nil }
        return keys[key]
    }
}
