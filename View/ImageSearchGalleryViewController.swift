//
//  ViewController.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 04/05/2022.
//

import UIKit
import Combine

class ImageSearchGalleryViewController: UIViewController {

    @IBOutlet weak var searchPhoto: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    private var bindings = Set<AnyCancellable>()
    
    
    private let viewModel:ImageSearchGalleryViewModelType = ImageSearchGalleryViewModel(networkManager: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        bindViewModelState()

    }
    
    override func didReceiveMemoryWarning() {
        viewModel.clearChachedData()
    }

    @IBAction func searchNow(_ sender: Any) {
        search()
    }
       
    private func search() {
        if let text = searchBar.text, text.count > 0{
            self.viewModel.search(keyword: text)
        }else {
            ImageGalleryUtility.shared.showAlert(GameViewController: self, title: "Alert", "Pls input some text to search")
        }
    }
    private func bindViewModelState() {
        let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    
    private func updateUI(state:ViewState) {
        switch state {
        //changes
        case .finishedLoading:
            navigateToImageGridView()
        case .none:
           print("")
        case .loading:
            print("")
        case .error(let error):
            ImageGalleryUtility.shared.showAlert(GameViewController: self, title: "Alert", error)
        }
    }
    
    func navigateToImageGridView() {
        
        let imageViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "imageGalleryViewController") as! ImageGalleryViewController
        
        imageViewControllerObj.viewModel = GalleryViewModel(imageRecords: viewModel.imageRecords)
        
        self.navigationController?.pushViewController(imageViewControllerObj, animated: true)
    }
}

extension ImageSearchGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchButton.isEnabled = true
        }else {
            searchButton.isEnabled = false
        }
    }

}
