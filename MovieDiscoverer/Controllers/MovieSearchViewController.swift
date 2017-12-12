//
//  MovieSearchViewController.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 07/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - MovieSearchViewController: UIViewController
class MovieSearchViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var certificationTextField: UITextField!
    @IBOutlet weak var searchButton: RoundedButton!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreTextField.loadPickerView(data: TMDBClient.MovieFilters.Genres)
        ratingTextField.loadPickerView(data: TMDBClient.MovieFilters.Ratings)
        certificationTextField.loadPickerView(data: TMDBClient.MovieFilters.Certifications)
    }
    
    // MARK: Actions
    
    @IBAction func discoverPressed(_ sender: Any) {
        
        if (genreTextField.text?.isEmpty)! || (ratingTextField.text?.isEmpty)! || (certificationTextField.text?.isEmpty)! {
            AlertView.showAlert(controller: self, message: AlertView.Messages.textFieldEmpty)
        } else {
            
            // Display gray overlay and activity indicator
            performUIUpdatesOnMain {
                self.overlay.isHidden = false
                self.activityIndicator.startAnimating()

            }
            
            TMDBClient.sharedInstance().discoverMovie(genre: genreTextField.text!, certification: certificationTextField.text!, rating: Int(ratingTextField.text!)!) { (movieDictionary, error) in
                
                if let error = error {
                    AlertView.showAlert(controller: self, message: error.localizedDescription)
                    
                    performUIUpdatesOnMain {
                        self.overlay.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                } else {

                    let detailsController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                    
                    // Save movieDictionary to Movie Details View Controller for later use
                    detailsController.movie = movieDictionary!
                    
                    performUIUpdatesOnMain {
                        self.overlay.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.pushViewController(detailsController, animated: true)
                    }
                }
            }
        }
    }
    
}

