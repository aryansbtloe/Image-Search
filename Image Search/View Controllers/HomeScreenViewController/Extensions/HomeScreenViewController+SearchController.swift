//
//  HomeScreenViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UISearchControllerDelegate,UISearchBarDelegate {    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        labelNoResultFound.isHidden = true
        searchResultsCollectionView.reloadData()
        imagesViewModel.searchText(text: text) {[weak self] (status, message) in
            if status {
                if (self?.imagesViewModel.arrayPhotos.count ?? 0) > 0 {
                    self?.labelNoResultFound.isHidden = true
                } else {
                    self?.labelNoResultFound.isHidden = false
                }
                self?.searchResultsCollectionView.reloadData()
            } else {
                self?.showAlert(with: message)
            }
        }
        searchController.searchBar.resignFirstResponder()
    }
    
}
