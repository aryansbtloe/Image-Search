//
//  TSAppConstants.swift
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

enum TSAppConstants {
    
    enum ViewControllers {
        
        enum HomeScreen {
            static let searchPlaceHolder = "eg- Flowers, Mountains"
            static let searchControllerNavigationTitle = "Search Photos"
        }
        
        enum ImageShowCase {
            static let storyBoardIdentifier = "TSImageShowCaseViewController"
        }

    }
    
    enum Cells {
        
        static let TSSingleImageCollectionViewCellNib = "TSSingleImageCollectionViewCell"
        
        enum Identifiers {
            static let TSSingleImageCollectionViewCell = TSAppConstants.Cells.TSSingleImageCollectionViewCellNib
        }
    }
    
    enum Networking {
        
        enum Flicker {

            static let apiKey = "a4f28588b57387edc18282228da39744"
            static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_%@.jpg"
            static let thumbnail = "t"
            static let medium = "c"
            static let searchURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&text=%@&page=%ld"
            
        }
        
        enum TSServerCommunicationManager {
            
            enum ErrorMessages {
                
                static let somethingWentWrong = "Something went wrong, Please try again later"
                static let noInternetConnection = "Please check your Internet connection and try again."

            }
            
        }
    }
    
    enum Tags {
    
        static let showCaseViewTag = 123
        
    }
}
