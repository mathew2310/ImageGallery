//
//  ImageGalleryUtility.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 11/05/2022.
//

import Foundation
import UIKit

class ImageGalleryUtility {
    
    static let shared = ImageGalleryUtility()
    private init() {}
    
    func showAlert( GameViewController:UIViewController,  title:String, _ message:String, dismissAlertAction:UIAlertAction? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let dismissAlertAction = dismissAlertAction {
            alertVC.addAction(dismissAlertAction)
        }else {
            alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        }
        GameViewController.present(alertVC, animated: true, completion: nil)
    }
}
