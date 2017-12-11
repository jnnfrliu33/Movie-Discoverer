//
//  TMDBConvenience.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 09/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TMDBClient (Convenient Resource Methods)

extension TMDBClient {
    
    // MARK: Get Convenience Methods
    
    func discoverMovie(genre: String, certification: String, rating: Int, completionHandlerForDiscoverMovie: @escaping (_ result: TMDBMovie?, _ error: NSError?) -> Void) {
        
        let genreID = generateGenreIDFromString(genre)
        
        var parameters = [ParameterKeys.Rating : rating,
                          ParameterKeys.Genre : genreID] as [String : AnyObject]
        
        // Check if user entered 'Any' for certification
        if certification != "Any" {
            parameters[ParameterKeys.Certification] = certification as AnyObject
            parameters[ParameterKeys.CertificationCountry] = ParameterValues.CertificationCountry as AnyObject
        }
        
        let _ = taskForGETMethod(Methods.DiscoverMovie, parameters: parameters as [String : AnyObject]) { (results, error) in
            
            if let error = error {
                completionHandlerForDiscoverMovie(nil, error)
            } else {
                if let totalPages = results?[JSONResponseKeys.MovieTotalPages] as? Int, totalPages > 0 {
                    let randomPage = self.generateRandomPage(withPageLimit: totalPages)
                    self.discoverMovie(genre: genre, certification: certification, rating: rating, withPageNumber: randomPage, completionHandlerForDiscoverMovie: completionHandlerForDiscoverMovie)
                } else {
                    completionHandlerForDiscoverMovie(nil, NSError(domain: "discoverMovie parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse discoverMovie"]))
                }
            }
        }
    }
    
    func discoverMovie(genre: String, certification: String, rating: Int, withPageNumber: Int, completionHandlerForDiscoverMovie: @escaping (_ result: TMDBMovie?, _ error: NSError?) -> Void) {
        
        let genreID = generateGenreIDFromString(genre)
        
        var parameters = [ParameterKeys.Rating : rating,
                          ParameterKeys.Genre : genreID,
                          ParameterKeys.Page : withPageNumber] as [String : AnyObject]
        
        // Check if user entered 'Any' for certification
        if certification != "Any" {
            parameters[ParameterKeys.Certification] = certification as AnyObject
            parameters[ParameterKeys.CertificationCountry] = ParameterValues.CertificationCountry as AnyObject
        }
        
        let _ = taskForGETMethod(Methods.DiscoverMovie, parameters: parameters as [String : AnyObject]) { (results, error) in
            
            if let error = error {
                completionHandlerForDiscoverMovie(nil, error)
            } else {
                if let results = results?[JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
                    let movie = TMDBMovie.randomMovieFromResults(results)
                    completionHandlerForDiscoverMovie(movie, nil)
                } else {
                    completionHandlerForDiscoverMovie(nil, NSError(domain: "discoverMovie parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse discoverMovie"]))
                }
            }
        }
    }
    
    // MARK: Helpers
    
    private func generateRandomPage(withPageLimit: Int) -> Int {
        let randomPage = Int(arc4random_uniform(UInt32(withPageLimit))) + 1
        return randomPage
    }
    
    private func generateGenreIDFromString(_ genreString: String) -> Int {
        
        let genresDictionary = ["Action": 28, "Adventure": 12, "Animation": 16, "Comedy": 35, "Crime": 80,
                                "Documentary": 99, "Drama": 18, "Family": 10751, "Fantasy": 14, "History": 36,
                                "Horror": 27, "Music": 10402, "Mystery": 9648, "Romance": 10749, "Science Fiction": 878,
                                "TV Movie": 10770, "Thriller": 53, "War": 10752, "Western": 37]
        
        return genresDictionary[genreString]!
    }
    
    static func generateGenreStringFromIDs(_ genreIDsArray: [Int]) -> String {
        
        let genresDictionary = [28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy", 80: "Crime",
                                99: "Documentary", 18: "Drama", 10751: "Family", 14: "Fantasy", 36: "History",
                                27: "Horror", 10402: "Music", 9648: "Mystery", 10749: "Romance", 878: "Science Fiction",
                                10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"]
        var genreString = ""
        
        for genreID in genreIDsArray {
            
            // Checks if genreID is in genresDictionary
            if let genreStringToAdd = genresDictionary[genreID] {
                if genreString == "" {
                    genreString += genreStringToAdd
                } else {
                    genreString += ", \(genreStringToAdd)"
                }
            }
        }
        
        return genreString
    }
}
