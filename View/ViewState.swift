//
//  ViewState.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 10/05/2022.
//

import Foundation


enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
