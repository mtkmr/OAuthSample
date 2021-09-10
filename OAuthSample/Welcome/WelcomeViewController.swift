//
//  WelcomeViewController.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/09.
//

import UIKit

final class WelcomeViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet private weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 10
            signInButton.addTarget(
                self,
                action: #selector(didTapSignInButton(_:)),
                for: .touchUpInside)
        }
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        navigationController?.navigationBar.barTintColor = .systemGreen
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    //MARK: - Functions
    func openUrl(_ url: URL) {
        guard let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
              let code = queryItems.first(where: {$0.name == "code"})?.value,
              let getState = queryItems.first(where: {$0.name == "state"})?.value,
              getState == APIClient.shared.qiitaState
        else {
            return
        }
        APIClient.shared.postAccessToken(code: code) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let accessToken):
                //端末にアクセストークンを保存しておく
                UserDefaults.standard.qiitaAccessToken = accessToken.token
                //ItemsVCへ遷移
                DispatchQueue.main.async {
                    let itemVC = UIStoryboard(name: "Items", bundle: nil).instantiateInitialViewController()!
                    self.navigationController?.pushViewController(itemVC, animated: true)
                }
            }
        }
    }
}

//MARK: - Private Extension
@objc
private extension WelcomeViewController {
    func didTapSignInButton(_ sender: UIButton) {
        //OAuth URLを開く
        UIApplication.shared.open(APIClient.shared.oAuthUrl,
                                  options: [:],
                                  completionHandler: nil)
    }
}
