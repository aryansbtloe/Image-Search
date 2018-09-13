//
//  BaseViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

/// <#Description#>
class BaseViewController: UIViewController {
    
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
    
    deinit {
        #if DEBUG
            print("deinit: \(self)")
        #endif
    }
}

