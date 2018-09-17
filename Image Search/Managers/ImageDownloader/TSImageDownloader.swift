//
//  TSImageDownloader.swift
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
typealias TSImageClosure = (Result<UIImage>,_ url: String) -> Void

/// <#Description#>
class TSImageDownloader: NSObject {
    
    static let shared = TSImageDownloader()
    private(set) var cache:NSCache<AnyObject, AnyObject> = NSCache()
    private var queue = OperationQueue()
    private var dictionaryBlocks = [UIImageView:(String, TSImageClosure, TSImageDownloadOperation)]()
    
    /// <#Description#>
    private override init() {
        queue.maxConcurrentOperationCount = TSAppConstants.ImageDownloader.maxConcurrentOperationCount
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - imageView: <#imageView description#>
    ///   - completion: <#completion description#>
    func addOperation(url: String, imageView: UIImageView,completion: @escaping TSImageClosure) {
        if let image = getImageFromCache(key: url)  {
            completion(.Success(image),url)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
        } else {
            if !checkOperationExists(with: url,completion: completion) {
                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                    tupple.2.cancel()
                }
                let newOperation = TSImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                    if let tupple = self.dictionaryBlocks[imageView] {
                        if tupple.0 == downloadedImageURL {
                            if let image = image {
                                self.saveImageToCache(key: downloadedImageURL, image: image)
                                tupple.1(.Success(image),downloadedImageURL)
                                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    tupple.2.cancel()
                                }
                            } else {
                                tupple.1(.Failure("Not fetched"), downloadedImageURL)
                            }
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                queue.addOperation(newOperation)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    internal func getImageFromCache(key : String) -> UIImage? {
        return self.cache.object(forKey: key as AnyObject) as? UIImage
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - image: <#image description#>
    internal func saveImageToCache(key : String, image : UIImage) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - completion: <#completion description#>
    /// - Returns: <#return value description#>
    func checkOperationExists(with url: String,completion: @escaping (Result<UIImage>,_ url: String) -> Void) -> Bool {
        if let arrayOperation = queue.operations as? [TSImageDownloadOperation] {
            let operations = arrayOperation.filter{$0.url == url}
            return operations.count > 0 ? true : false
        }
        return false
    }
}

extension UIImageView {
    
    /// <#Description#>
    ///
    /// - Parameter url: <#url description#>
    func setImage(with url: String){
        self.showActivityIndicator()
        TSImageDownloader.shared.addOperation(url: url,imageView: self) {  [weak self] (result,downloadedImageURL) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let image):
                    self?.image = image
                case .Failure(_):
                    break
                case .Error(_):
                    break
                }
                self?.hideActivityIndicator()
            }
        }
    }
    
}
