//
//  MovieTableViewController.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit
import CoreData

// MARK: - MovieTableViewController: UITableViewController

class MovieTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // To keep track of deletions and updates
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!

    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStack.sharedInstance().context
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        // Create fetch request with sort descriptor
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Create controller from fetch request
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch persisted movies
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print ("Unable to fetch photos!")
        }
    }
}

// MARK: - MovieTableViewController (Table View Data Source)
    
extension MovieTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        if let fetchedMovies = self.fetchedResultsController.fetchedObjects, fetchedMovies.count > 0 {
            let movieObject = fetchedMovies[(indexPath as NSIndexPath).item] as! Movie

            cell.textLabel?.text = movieObject.title
            cell.detailTextLabel?.text = movieObject.genre
            cell.imageView?.image = UIImage(data: movieObject.poster! as Data)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let fetchedMovies = self.fetchedResultsController.fetchedObjects, fetchedMovies.count > 0 {
            let movieObject = fetchedMovies[(indexPath as NSIndexPath).item] as! Movie
            
            let detailsController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            detailsController.selectedMovie = movieObject
            
            self.navigationController?.pushViewController(detailsController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let fetchedMovies = self.fetchedResultsController.fetchedObjects {
                self.sharedContext.delete(fetchedMovies[(indexPath as NSIndexPath).item] as! NSManagedObject)
            }
            
            // Save context
            self.sharedContext.performAndWait {
                do {
                    try CoreDataStack.sharedInstance().saveContext()
                } catch {
                    print ("Unable to save context!")
                }
            }
        }
    }
}

// MARK: - MovieTableViewController: NSFetchedResultsControllerDelegate

extension MovieTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Create fresh arrays when controller is about to make changes
        self.insertedIndexPaths = [IndexPath]()
        self.deletedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            self.deletedIndexPaths.append(indexPath!)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Perform batch updates
        self.tableView.performBatchUpdates({ () -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            for indexPath in self.deletedIndexPaths {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }, completion: nil)
    }
}

