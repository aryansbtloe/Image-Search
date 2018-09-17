//
//  TSHomeScreenViewController.swift
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
class TSHomeScreenViewController: TSBaseViewController {
    
    /// <#Description#>
    internal var searchController: UISearchController!
    internal var maximumImagesInARow: UInt = 3
    internal var isFirstTimeActive = true
    internal var selectedFrame : CGRect?
    internal var selectedImage:UIImage?
    internal var imagesViewModel = TSImagesViewModel()

    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var labelNoResultFound: UILabel!
    
    /// <#Description#>
    override internal func viewDidLoad() {
        super.viewDidLoad()
        startUpInitialisations()
        setupForNavigationBar()
        registerForNotifications()
        updateUserInterfaceOnScreen()
    }
    
    /// <#Description#>
    internal func startUpInitialisations(){
        setupForSearchController()
        setupForCollectionView()
        makeSearchControllerActive(withDelay: 2)
    }
    
    /// <#Description#>
    internal func setupForNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.delegate = self
        self.title = TSAppConstants.ViewControllers.HomeScreen.searchControllerNavigationTitle
    }

    /// <#Description#>
    internal func registerForNotifications(){
        
    }
    
    /// <#Description#>
    internal func updateUserInterfaceOnScreen(){
        
    }

    /// <#Description#>
    internal func setupForSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.placeholder = TSAppConstants.ViewControllers.HomeScreen.searchPlaceHolder
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    /// <#Description#>
    internal func setupForCollectionView() {
        let nib = UINib(nibName: TSAppConstants.Cells.TSSingleImageCollectionViewCellNib, bundle: Bundle.main)
        let identifier = TSAppConstants.Cells.Identifiers.TSSingleImageCollectionViewCell
        searchResultsCollectionView.register(nib, forCellWithReuseIdentifier:identifier)
    }

    /// <#Description#>
    ///
    /// - Parameter delay: <#delay description#>
    internal func makeSearchControllerActive(withDelay delay:TimeInterval=2) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func optionDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: TSAppConstants.Alerts.HowManyImagesToShowInARow.title, message: TSAppConstants.Alerts.HowManyImagesToShowInARow.message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Two", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 2
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Three", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 3
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Four", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 4
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion:nil)
    }
    
    /// <#Description#>
    internal func loadNextPage() {
        imagesViewModel.fetchNextPage { [weak self](status, message) in
            if status {
                self?.searchResultsCollectionView.reloadData()
            }
        }
    }

}



