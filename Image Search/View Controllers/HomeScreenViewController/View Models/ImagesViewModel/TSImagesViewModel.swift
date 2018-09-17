//
//  TSImagesViewModel.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org>


import UIKit

/// <#Description#>
class TSImagesViewModel: NSObject {
    let manager: TSServerCommunicationManager
    private var pageNo = 1
    private var totalPageNo = 1
    private(set) var images = [TSImageModel]()
    private(set) var cache:NSCache<AnyObject, AnyObject> = NSCache()
    private var searchText = ""
    
    /// <#Description#>
    ///
    /// - Parameter manager: <#manager description#>
    init(manager: TSServerCommunicationManager = TSServerCommunicationManager.shared) {
        self.manager = manager
        super.init()
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - completion: <#completion description#>
    func searchText(text: String,completion:(@escaping (Bool,String) -> Void)) {
        searchText = text
        images.removeAll()
        fetchResult(completion: completion)
    }
    
    /// <#Description#>
    ///
    /// - Parameter completion: <#completion description#>
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
                            completion(status,TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong)
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
    
    /// <#Description#>
    ///
    /// - Parameter completion: <#completion description#>
    func fetchNextPage(completion:(@escaping (Bool,String) -> Void)) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResult(completion: completion)
        } else {
            completion(false,"")
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - dict: <#dict description#>
    ///   - callback: <#callback description#>
    internal func parseData(dict: [String: Any], callback: @escaping (Bool) -> Void) {
        guard let photos = dict["photos"] as? [String: Any] else {
            callback(false)
            return
        }
        totalPageNo = photos["pages"] as? Int ?? 1
        if let photoArray = photos["photo"] as? [[String:Any]] {
            for photoDict in photoArray {
                let model = TSImageModel(dictionary: photoDict)
                images.append(model)
            }
            callback(true)
        }
    }
    
}
