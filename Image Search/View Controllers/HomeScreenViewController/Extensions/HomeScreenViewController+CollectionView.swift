//
//  HomeScreenViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleImageCollectionViewCell", for: indexPath) as! SingleImageCollectionViewCell
        cell.photoImage.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SingleImageCollectionViewCell else {
            return
        }
        let model = imagesViewModel.arrayPhotos[indexPath.row]
        cell.model = model
        
        if indexPath.row == (imagesViewModel.arrayPhotos.count - 1) {
            loadNextPage()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesViewModel.arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/CGFloat(maximumImagesInARow), height: (collectionView.bounds.width)/CGFloat(maximumImagesInARow))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        self.searchController.isActive = false
        perform(#selector(pushDetailView), with: indexPath, afterDelay: 0.1)
    }
    
    @objc func pushDetailView(indexPath: IndexPath){
        guard let cell = searchResultsCollectionView.cellForItem(at: indexPath) as? SingleImageCollectionViewCell else {
            return
        }
    }
}



