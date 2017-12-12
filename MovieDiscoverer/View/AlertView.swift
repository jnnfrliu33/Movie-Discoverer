//
//  AlertView.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - AlertView

class AlertView {
    
    class func showAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "Something's wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        performUIUpdatesOnMain {
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    struct Messages {
        static let textFieldEmpty = "Please make sure you've filled in all fields."
        static let fetchMovieFailed = "Uh oh, unable to find any movie that matches your criteria. :( Please try a different set of criteria."
        static let duplicateMovie = "This movie is already on your watchlist. ;)"
    }
}
