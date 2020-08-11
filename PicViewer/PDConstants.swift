//
//  PDConstants.swift
//  PicViewer
//
//  Created by Penchal on 11/08/20.
//  Copyright © 2020 senix.com. All rights reserved.
//



import Foundation
import UIKit


//MARK: - Base Url and Google Map Key

let baseUrl = "https://picsum.photos/v2/list?page=2&limit=20"

//MARK: - Cell Identifiers -

let tableCell = "UserDetailsCell"

//MARK: - Storyboard IDs -

let keyUserDetailsVC = "UserDetailsViewController"

//MARK: - Alert Messages -

let keyError = "Error!"
let keyNetConnect = "Please connect to Internet"


//MARK: - Network Responses -

enum NetworkResponse:String {
    case success
    case unautherized
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
    case unautherized
}

enum HTTPMethod:String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

//customer name, customer number,  latitude, longitude
