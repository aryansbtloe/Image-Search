//
//  ImagesViewModel.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

class ImagesViewModel: NSObject {
    let manager: APIManager
    private var pageNo = 1
    private var totalPageNo = 1
    private(set) var arrayPhotos = [TSImageModel]()
    private(set) var cache:NSCache<AnyObject, AnyObject> = NSCache()
    private var searchText = ""
    
    init(manager: APIManager = APIManager.shared) {
        self.manager = manager
        super.init()
    }
    
    func searchText(text: String,completion:(@escaping (Bool,String) -> Void)) {
        searchText = text
        arrayPhotos.removeAll()
        fetchResult(completion: completion)
    }
    
    internal func fetchResult(completion:(@escaping (Bool,String) -> Void)) {
        let urlString = String(format: TSAppConstants.Networking.Flicker.searchURL,searchText,pageNo)
        guard let request = Request.init(requestMethod: RequestMethod.get, urlString: urlString) else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        manager.executeRequest(request: request) { (result) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch result {
                case .Success(let responseDict):
                    self.parseData(dict: responseDict) { (status) in
                        if status {
                            completion(status,"")
                        }
                        else{
                            completion(status,APIManager.errorMessage)
                        }
                    }
                case .Failure(let message):
                    completion(false, message)
                case .Error(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    func fetchNextPage(completion:(@escaping (Bool,String) -> Void)) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResult(completion: completion)
        } else {
            completion(false,"")
        }
    }
    
    internal func parseData(dict: [String: Any], callback: @escaping (Bool) -> Void) {
        guard let photos = dict["photos"] as? [String: Any] else {
            callback(false)
            return
        }
        totalPageNo = photos["pages"] as? Int ?? 1
        if let photoArray = photos["photo"] as? [[String:Any]] {
            for photoDict in photoArray {
                let model = TSImageModel(dict: photoDict)
                arrayPhotos.append(model)
            }
            callback(true)
        }
    }
    
}
