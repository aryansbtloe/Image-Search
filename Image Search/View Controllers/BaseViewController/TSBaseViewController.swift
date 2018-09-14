//
//  TSBaseViewController.swift
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
class TSBaseViewController: UIViewController {
    
    /// <#Description#>
    ///
    /// - Parameter text: <#text description#>
    func showAlert(with text:String?) {
        DispatchQueue.main.async {
            guard let alertText = text else {return}
            let alertController = UIAlertController(title: "Info", message: alertText, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func storyBoard()->UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter identifier: <#identifier description#>
    /// - Returns: <#return value description#>
    func viewControllerObject(identifier:String) -> UIViewController {
        return storyBoard().instantiateViewController(withIdentifier:identifier)
    }
    
    deinit {
        #if DEBUG
            print("deinit: \(self)")
        #endif
    }
}

