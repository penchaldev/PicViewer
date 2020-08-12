//
//  PVNetworkManager.swift
//  PicViewer
//
//  Created by Penchal on 11/08/20.
//  Copyright © 2020 senix.com. All rights reserved.
//



import Foundation
import UIKit

class PVNetworkManager: NSObject,URLSessionDelegate {

    static let sharedInstance = PVNetworkManager()
    
    // Configuration
    static var task: URLSessionTask?
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
            config.timeoutIntervalForRequest = 60.0
        } else {
            // Fallback on earlier versions
        }
        return URLSession(configuration: config)
    }()
    
 //MARK: - Get SERVICE CALL -
    
static func getServiceCall(completionHandler:@escaping(picDetails) -> Void){
    
    if !Reachability.isConnectedToNetwork() {
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            keyWindow?.rootViewController?.showAlert(message: keyNetConnect, title: keyError)
        }
        return
    }
    
    DispatchQueue.global(qos:.userInitiated).async {
        let urlString = baseUrl
        var request =  URLRequest(url: URL(string:urlString)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        print("Final Request:::",request)
        
        task = session.dataTask(with: request, completionHandler: { (responseData, response, responseError) in
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                        do {
                          let apiResponse = try JSONDecoder().decode(picDetails.self, from: data)
                            print(apiResponse)
                            
                            DispatchQueue.main.async {
                                completionHandler(apiResponse)
                            }
                        }
                        catch let error {
                            print("Parsing Error:\(error)")
                        }
                    }
                case .unautherized:
                    return
                case .failure(_):
                    return
                }
            }
        })
        task?.resume()
    }
}
    

 static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
        case 200...299: return .success
        case 401: return .unautherized
        case 402...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
    }
  }
 }

