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

extension TSHomeScreenViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TSSingleImageCollectionViewCell", for: indexPath) as! TSSingleImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TSSingleImageCollectionViewCell else {
            return
        }
        let model = imagesViewModel.images[indexPath.row]
        cell.imageModel = model
        
        if indexPath.row == (imagesViewModel.images.count - 1) {
            loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesViewModel.images.count
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
        
        guard let cell = searchResultsCollectionView.cellForItem(at: indexPath) as? TSSingleImageCollectionViewCell else {return}
        
        if let imageToShow = cell.imageView.image , let viewController = viewControllerObject(identifier: TSAppConstants.ViewControllers.ImageShowCase.storyBoardIdentifier) as? TSImageShowCaseViewController {
            self.selectedImage = imageToShow
            let imageModel = imagesViewModel.images[indexPath.row]
            let showCaseViewModel = TSShowCaseViewModel(model: imageModel)
            viewController.viewModel = showCaseViewModel
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}



