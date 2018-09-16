//
//  TSExtensions.swift
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

extension Dictionary {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - defaultValue: <#defaultValue description#>
    /// - Returns: <#return value description#>
    func getStringKey(_ key: Key , defaultValue:String? = nil) -> String? {
        if let value = self[key] as? String, !value.isEmpty {
            return value
        }
        return defaultValue
    }
    
}

extension UIView {
    
    func showActivityIndicator() {
        if let activityIndicator = self.viewWithTag(TSAppConstants.Tags.activityIndicatorViewTag) as? UIActivityIndicatorView {
            activityIndicator.startAnimating()
        }else{
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.tag = TSAppConstants.Tags.activityIndicatorViewTag
            self.addSubview(activityIndicatorView)
            let horizontalConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.addConstraint(horizontalConstraint)
            self.addConstraint(verticalConstraint)
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        self.viewWithTag(TSAppConstants.Tags.activityIndicatorViewTag)?.removeFromSuperview()
    }
    
}
