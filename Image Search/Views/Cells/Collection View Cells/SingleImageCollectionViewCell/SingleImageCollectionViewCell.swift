//
//  SingleImageCollectionViewCell.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

class SingleImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    var model: TSImageModel? {
        didSet {
            if let model = model {
                photoImage.image = UIImage(named: "placeholder")
                photoImage.downloadImage(with: model.image)
            }
        }
    }
}
