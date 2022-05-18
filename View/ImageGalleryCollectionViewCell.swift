//
//  PixbyImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 04/05/2022.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pixabayImage: UIImageView!
    
    override func prepareForReuse() {
        self.pixabayImage.image = nil
    }

}


