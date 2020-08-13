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
        }else {
            return
        }
    }
    
    //MARK: Fetching data through API Call
    
    func serverCalls() {
        
        showActivityIndicator(progressLabel: "Fetching Data")
        PVNetworkManager.getServiceCall() { (weatherObject) in
            self.picData = weatherObject
            
            print("Image URL: \(self.picData?[0].url)")
            print("Download URL \(self.picData?[0].downloadURL)")
            
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.picTableView.reloadData()
            }
        }
    }
    func refreshTableViewController(){
               refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
               picTableView.refreshControl = refreshControl
           }
       
    @objc func pullToRefresh(sender: UIRefreshControl){
        print("Performing Pull-Refresh")
        self.picTableView.reloadData()
              
    }
    
}

//MARK: Table View delegate and datasource methods

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return picData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = picTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PicTableViewCell
            cell.authorName.text = ("Author: \(picData?[indexPath.row].author ?? "")")
            cell.picID.text = ("ID: \(picData?[indexPath.row].id ?? "")")
        
        let image = self.picData?[indexPath.row].downloadURL
            print("Pic Url In Cell for : \(image)")
        
        DispatchQueue.global().async {
            if let url = URL(string: image ?? "")  {
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
    
        return view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.showAlert(message: ("Author: \(picData?[indexPath.row].author ?? "")"), title: ("ID: \(picData?[indexPath.row].id ?? "")"))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("Printing the upcoming index: \(indexPath.row)")
    }
    
}

