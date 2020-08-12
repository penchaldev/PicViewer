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
    //    var picData: picDetails?
    //     var picData: [[PicModel]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Reachability.isConnectedToNetwork() {
            serverCalls()
        }else {
            return
        }
    }
    
    func serverCalls() {
        
        showActivityIndicator(progressLabel: "Fetching Data")
        PVNetworkManager.getServiceCall() { (weatherObject) in
            self.picData = weatherObject
            
            print("Image URL: \(self.picData?[0].url)")
            print("Download URL \(self.picData?[0].downloadURL)")
//          print("Fetched Data: \(weatherObject)")
            
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.picTableView.reloadData()
            }
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("pic data Count: \(picData?.count)")
        return picData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PicTableViewCell
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}

