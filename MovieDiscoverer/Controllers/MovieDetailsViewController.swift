//
//  MovieDetailsViewController.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit
import CoreData

// MARK: - MovieDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate

class MovieDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    @IBOutlet weak var addToWatchlistButton: RoundedButton!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var selectedMovie: Movie? = nil
    var movie: TMDBMovie?
    var imageData: NSData?
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStack.sharedInstance().context
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        // Create fetch request with sort descriptor
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.sortDescriptors = []
        
        // Create controller from fetch request
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if movie is persisted
        if selectedMovie != nil {
            
            // Fetch persisted movies
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print ("Unable to fetch movies!")
            }
            
            // Set the movie details
            movieTitleLabel.text = selectedMovie?.title
            releaseDateLabel.text = selectedMovie?.releaseDate
            genreLabel.text = selectedMovie?.genre
            ratingLabel.text = String(describing: Int((selectedMovie?.rating)!))
            synopsisLabel.text = selectedMovie?.synopsis
            posterImage.image = UIImage(data: (selectedMovie?.poster as Data?)!)
            
        } else if movie != nil {
            
            // Set the movie details
            movieTitleLabel.text = movie?.title
            releaseDateLabel.text = movie?.releaseDate
            genreLabel.text = movie?.genres
            ratingLabel.text = String(describing: Int((movie?.rating)!))
            synopsisLabel.text = movie?.synopsis
            
            // Download and set the movie poster
            if let posterPath = movie?.posterPath {
                let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath) { (imageData, error) in
                    
                    if let error = error {
                        AlertView.showAlert(controller: self, message: error.localizedDescription)
                        
                        performUIUpdatesOnMain {
                            self.imageActivityIndicator.stopAnimating()
                        }
                    } else {
                        
                        self.imageData = imageData as NSData?
                        
                        performUIUpdatesOnMain {
                            self.posterImage.image = UIImage(data: self.imageData! as Data)
                            self.imageActivityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func addToWatchlist(_ sender: Any) {
        
        // Fetch persisted movies
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print ("Unable to fetch movies!")
        }
        
        // Check if the movie has already been added to the watchlist
        for fetchedObject in self.fetchedResultsController.fetchedObjects! {
            let persistedMovie = fetchedObject as! Movie
            if movie?.title == persistedMovie.title || selectedMovie?.title == persistedMovie.title {
                AlertView.showAlert(controller: self, message: AlertView.Messages.duplicateMovie)
                return
            }
        }
        
        sharedContext.performAndWait {
            // Create Movie object
            _ = Movie(title: (movie?.title)!, releaseDate: (movie?.releaseDate)!, rating: (movie?.rating)!, genre: (movie?.genres)!, synopsis: (movie?.synopsis)!, poster: imageData! ,context: sharedContext)
            
            // Save context
            do {
                try CoreDataStack.sharedInstance().saveContext()
            } catch {
                print ("Unable to save context!")
            }
        }
    }
}
