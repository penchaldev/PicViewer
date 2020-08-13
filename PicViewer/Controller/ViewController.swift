//
//  ViewController.swift
//  PicViewer
//
//  Created by Penchal on 11/08/20.
//  Copyright © 2020 senix.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var picTableView: UITableView!
    var picData: [PicModel]?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTableViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if Reachability.isConnectedToNetwork() {
            serverCalls()
        } else {
            return
        }
    }

//MARK: Fetching data through API Call
    func serverCalls() {
        showActivityIndicator(progressLabel: "Fetching Data")
        PVNetworkManager.getServiceCall() { (weatherObject) in
            self.picData = weatherObject

            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.picTableView.reloadData()
            }
        }
    }

//MARK: Pull to Refresh TableView
    func refreshTableViewController() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        let string = "Refreshing"
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 20)
        ]

        let attributedString = NSAttributedString(string: string, attributes: attributes)
        refreshControl.attributedTitle = attributedString
        picTableView.refreshControl = refreshControl
    }

    @objc func pullToRefresh(sender: UIRefreshControl) {
        print("Performing Pull-Refresh")
        serverCalls()
        self.refreshControl.endRefreshing()
        self.hideActivityIndicator()
    }
}

//MARK: Table View delegate and datasource methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = picTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PicTableViewCell
        cell.authorName.text = ("Author: \(picData?[indexPath.row].author ?? "")")
        cell.picID.text = ("ID: \(picData?[indexPath.row].id ?? "")")

        let image = self.picData?[indexPath.row].downloadURL

        DispatchQueue.global().async {
            if let url = URL(string: image ?? "") {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.tableCellPiture.image = image
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height) / 2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(message: ("Author: \(picData?[indexPath.row].author ?? "")"), title: ("ID: \(picData?[indexPath.row].id ?? "")"))
    }

}

