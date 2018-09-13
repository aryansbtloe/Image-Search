//
//  TSImageModel.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

struct TSImageModel {
    let id : String
    let farm: Int
    let server: String
    let secret: String
    let title: String
    let image: String
    let largeSizeimage: String
    init(dict: [String:Any]) {
        id = dict.getStringKey("id")
        farm = dict["farm"] as? Int ?? 1
        server = dict.getStringKey("server")
        secret = dict.getStringKey("secret")
        title = dict.getStringKey("title")
        image = String(format: TSAppConstants.Networking.Flicker.imageURL, farm,server,id,secret,TSAppConstants.Networking.Flicker.thumbnail)
        largeSizeimage = String(format: TSAppConstants.Networking.Flicker.imageURL, farm,server,id,secret,TSAppConstants.Networking.Flicker.medium)
    }
}

extension Dictionary {
    func getStringKey(_ key: Key) -> String {
        if let y = self[key] as? String, !y.isEmpty {
            return y
        }
        return ""
    }
    
}
