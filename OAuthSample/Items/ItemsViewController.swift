//
//  ItemsViewController.swift
//  OAuthSample
//
//  Created by Masato Takamura on 2021/09/09.
//

import UIKit
import SafariServices

final class ItemsViewController: UIViewController {

    @IBOutlet private weak var itemsTableView: UITableView! {
        didSet {
            itemsTableView.delegate = self
            itemsTableView.dataSource = self
            itemsTableView.register(UITableViewCell.self,
                                    forCellReuseIdentifier: UITableViewCell.className)
        }
    }

    private var qiitaItems: [QiitaItemModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Qiita記事一覧"
        navigationItem.hidesBackButton = true
        APIClient.shared.getItems { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let items):
                self?.qiitaItems = items
                DispatchQueue.main.async {
                    self?.itemsTableView.reloadData()
                }
            }
        }
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let url = URL(string: qiitaItems[indexPath.row].url)
        else { return }

        DispatchQueue.main.async {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .fullScreen
            safariVC.dismissButtonStyle = .done
            safariVC.preferredBarTintColor = .systemGreen
            safariVC.preferredControlTintColor = .white
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        qiitaItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        let item = qiitaItems[indexPath.row]
        cell.textLabel?.text = item.title

        return cell
    }


}
