//
//  TSImageDownloadOperation.swift
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
class TSImageDownloadOperation: Operation {
    
    /// <#Description#>
    let url : String?
    
    /// <#Description#>
    var completion: ((_ image : UIImage?,_ url: String) -> Void)?
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - completion: <#completion description#>
    init(url : String, completion : @escaping ((_ image : UIImage?,_ url : String) -> Void)) {
        self.url = url
        self.completion = completion
    }
    
    /// <#Description#>
    override func main() {
        if self.isCancelled { return }
        if let url = self.url {
            TSServerCommunicationManager.shared.downloadImage(urlString: url) { (result) in
                DispatchQueue.main.async {
                    if self.isCancelled { return }
                    switch result {
                    case .Success(let image):
                        if let block = self.completion{
                            block(image, url)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}
