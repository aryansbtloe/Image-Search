//
//  TSAppConstants.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit



enum TSAppConstants {
    
    enum HomeScreen {
        
        static let searchPlaceHolder = "Search eg- Flowers, Mountains"
        static let searchControllerNavigationTitle = "Search"
        
    }
    
    enum Cells {
        
        static let singleImageCollectionViewCellNib = "SingleImageCollectionViewCell"
        
        enum Identifiers {
            static let singleImageCollectionViewCell = TSAppConstants.Cells.singleImageCollectionViewCellNib
        }
    }
    
    enum Networking {
        
        enum Flicker {

            static let apiKey = "a4f28588b57387edc18282228da39744"
            static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_%@.jpg"
            static let thumbnail = "t"
            static let medium = "c"
            static let searchURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(TSAppConstants.Networking.Flicker.apiKey)&format=json&text=%@&page=%ld"
            
        }
        
    }
}
