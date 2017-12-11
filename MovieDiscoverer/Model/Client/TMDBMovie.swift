//
//  TMDBMovie.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 09/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation

// MARK: - TMDBMovie

struct TMDBMovie {
    
    // MARK: Properties
    
    let title: String?
    let id: Int?
    let posterPath: String?
    let releaseDate: String?
    let genres: String?
    let rating: Double?
    let synopsis: String?
    
    // MARK: Initializers
    
    // Construct a TMDBMovie from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        if let titleString = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as? String, !titleString.isEmpty {
            title = titleString
        } else {
            title = ""
        }
        
        if let idInt = dictionary[TMDBClient.JSONResponseKeys.MovieID] as? Int, idInt > 0 {
            id = idInt
        } else {
            id = 0
        }
        
        if let posterPathString = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String, !posterPathString.isEmpty {
            posterPath = posterPathString
        } else {
            posterPath = ""
        }
        
        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String, !releaseDateString.isEmpty {
            releaseDate = releaseDateString
        } else {
            releaseDate = ""
        }
        
        if let genreIDsArray = dictionary[TMDBClient.JSONResponseKeys.MovieGenres] as? [Int] {
            genres = TMDBClient.generateGenreStringFromIDs(genreIDsArray)
        } else {
            genres = ""
        }
        
        if let ratingNumber = dictionary[TMDBClient.JSONResponseKeys.MovieRating] as? Double, ratingNumber > 0 {
            rating = ratingNumber
        } else {
            rating = 0.0
        }
        
        if let synopsisString = dictionary[TMDBClient.JSONResponseKeys.MovieSynopsis] as? String, !synopsisString.isEmpty {
            synopsis = synopsisString
        } else {
            synopsis = ""
        }
    }
    
    static func randomMovieFromResults(_ results: [[String:AnyObject]]) -> TMDBMovie {
        
        let totalMovies = results.count
        let randomMovieIndex = Int(arc4random_uniform(UInt32(totalMovies)))
        let randomMovieDictionary = results[randomMovieIndex]
        
        return TMDBMovie(dictionary: randomMovieDictionary)
    }
}

