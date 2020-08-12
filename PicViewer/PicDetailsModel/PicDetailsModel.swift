//
//  PicDetailsModel.swift
//  PicViewer
//
//  Created by Penchal on 11/08/20.
//  Copyright © 2020 senix.com. All rights reserved.
//

import Foundation

// MARK: - PicDetails
struct PicModel: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias picDetails = [PicModel]
