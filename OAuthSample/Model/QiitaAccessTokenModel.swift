//
//  QiitaAccessTokenModel.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/09.
//

import Foundation

struct QiitaAccessTokenModel: Codable {
    let clientId: String
    let scopes: [String]
    let token: String
}
