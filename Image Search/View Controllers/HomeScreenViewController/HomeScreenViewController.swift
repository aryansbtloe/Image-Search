//
//  HomeScreenViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

class HomeScreenViewController: BaseViewController {
    
    internal var searchController: UISearchController!
    internal var maximumImagesInARow: UInt = 3
    internal var isFirstTimeActive = true
    internal var selectedFrame : CGRect?
    internal var interactor : TSInteractor?
    internal var selectedImage:UIImage?
    internal var imagesViewModel = ImagesViewModel()

    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var labelNoResultFound: UILabel!
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        startUpInitialisations()
        setupForNavigationBar()
        registerForNotifications()
        updateUserInterfaceOnScreen()
    }
    
    internal func startUpInitialisations(){
        setupForSearchController()
        setupForCollectionView()
        makeSearchControllerActive(withDelay: 2)
    }
    
    internal func setupForNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.delegate = self
    }

    internal func registerForNotifications(){
        
    }
    
    internal func updateUserInterfaceOnScreen(){
        
    }

    internal func setupForSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.placeholder = TSAppConstants.HomeScreen.searchPlaceHolder
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    internal func setupForCollectionView() {
        let nib = UINib(nibName: TSAppConstants.Cells.singleImageCollectionViewCellNib, bundle: Bundle.main)
        let identifier = TSAppConstants.Cells.Identifiers.singleImageCollectionViewCell
        searchResultsCollectionView.register(nib, forCellWithReuseIdentifier:identifier)
    }

    internal func makeSearchControllerActive(withDelay delay:TimeInterval=2) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    //MARK: @IBAction
    @IBAction func optionTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Images", message: "How many images to show in a row?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "2", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 2
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "3", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 3
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "4", style: .default , handler:{ (UIAlertAction)in
            self.maximumImagesInARow = 4
            self.searchResultsCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion:nil)
    }
    
    internal func loadNextPage() {
        imagesViewModel.fetchNextPage { [weak self](status, message) in
            if status {
                self?.searchResultsCollectionView.reloadData()
            }
        }
    }
    

}



