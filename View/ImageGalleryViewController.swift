//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 04/05/2022.
//

import UIKit
import Combine
class ImageGalleryViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: GalleryViewModel?
    private var bindings = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinding()
    }

    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupBinding() {
        viewModel?.$imageState.dropFirst().receive(on: RunLoop.main).sink(receiveValue: { state in
            
            switch state {
            case .startDownLoad(_):
                print("download started")
            case .downLoadCompleted(let indexPath):
                self.collectionView.reloadItems(at: [indexPath])
            case .none:
                print("no- operation")
            }
        }).store(in: &bindings)
    }
  
}


extension ImageGalleryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageRecords.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageGalleryCollectionViewCell
          else {return UICollectionViewCell()}
        
        if let imageDetail = viewModel?.imageRecords[indexPath.row]{
            
            switch (imageDetail.state) {
           
                   case .failed:
                       collectionCell.pixabayImage.image = UIImage(named: "Failed")
           
                   case .new:
                viewModel?.startDownload(imageDownloader: ImageDownloader(imageDetail), at: indexPath)
           
                   case .downloaded :
                collectionCell.pixabayImage.image = imageDetail.image
           
                   }
                   
        }
          return collectionCell
      }

}

extension ImageGalleryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:widthPerItem)
    }
  
}



    

