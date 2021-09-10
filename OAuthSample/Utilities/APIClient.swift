//
//  APICaller.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/09.
//

import Foundation

enum APIError: Error {
    case postAccessToken
    case getItems
    case decode

    var description: String {
        switch self {
        case .postAccessToken:
            return "POST error"
        case .getItems:
            return "GET error"
        case .decode:
            return "Decoding error"
        }
    }
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    //URL Components
    private let host = "https://qiita.com/api/v2"
    private let clientId: String = KeyManager.shared.getValue(key: "clientId") as! String
    private let clientSecret: String = KeyManager.shared.getValue(key: "clientSecret") as! String
    let qiitaState = "bb17785d811bb1913ef54b0a7657de780defaa2d"

    //Decoder
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    //URLParameter Key
    enum URLParameterName: String {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case scope = "scope"
        case state = "state"
        case code = "code"
    }

    //OAuth URL
    var oAuthUrl: URL {
        let endPoint = "/oauth/authorize"
        return URL(string: host + endPoint + "?" +
                    "\(URLParameterName.clientId.rawValue)=\(clientId)" + "&" +
                    "\(URLParameterName.scope.rawValue)=read_qiita" + "&" +
                    "\(URLParameterName.state.rawValue)=\(qiitaState)")!
    }

    ///Post
    func postAccessToken(code: String, completion: ((Result<QiitaAccessTokenModel, APIError>) -> Void)? = nil) {
        let endPoint = "/access_tokens"
        guard
            let url = URL(string: host + endPoint)
        else {
            completion?(.failure(APIError.postAccessToken))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [URLParameterName.clientId.rawValue:clientId,
                                   URLParameterName.clientSecret.rawValue: clientSecret,
                                   URLParameterName.code.rawValue: code]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion?(.failure(APIError.postAccessToken))
                return
            }
            guard
                let data = data
            else {
                completion?(.failure(APIError.postAccessToken))
                return
            }
            do {
                let accessToken = try APIClient.jsonDecoder.decode(QiitaAccessTokenModel.self, from: data)
                completion?(.success(accessToken))
            } catch {
                completion?(.failure(APIError.postAccessToken))
            }
        }
        task.resume()
    }

    ///Get Items
    func getItems(completion: ((Result<[QiitaItemModel], Error>) -> Void)? = nil) {
        let endPoint = "/authenticated_user/items"
        guard
            var urlComponents = URLComponents(string: host + endPoint),
            !UserDefaults.standard.qiitaAccessToken.isEmpty
        else {
            completion?(.failure(APIError.getItems))
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "page", value: "1"),
                                    URLQueryItem(name: "per_page", value: "20")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(UserDefaults.standard.qiitaAccessToken)"
        ]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion?(.failure(APIError.getItems))
                return
            }
            guard let data = data else {
                completion?(.failure(APIError.getItems))
                return
            }
            do {
                let items = try APIClient.jsonDecoder.decode([QiitaItemModel].self, from: data)
                completion?(.success(items))
            } catch {
                completion?(.failure(error))
            }
        }
        task.resume()
    }

}
