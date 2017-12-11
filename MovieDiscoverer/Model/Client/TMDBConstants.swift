//
//  TMDBConstants.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 08/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation

// MARK: - TMDBClient (Constants)

extension TMDBClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "37f152280a08abb00ce2d8ae1c99ecf6"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let BaseImageURLString =  "https://image.tmdb.org/t/p/"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Discover Movie
        static let DiscoverMovie = "/discover/movie"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Query = "query"
        static let Certification = "certification"
        static let CertificationCountry = "certification_country"
        static let Genre = "with_genres"
        static let Rating = "vote_average.gte"
        static let Page = "page"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let CertificationCountry = "US"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Movie
        static let MovieResults = "results"
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieGenres = "genre_ids"
        static let MovieRating = "vote_average"
        static let MovieSynopsis = "overview"
        static let MovieTotalPages = "total_pages"
    }
    
    // MARK: Poster Sizes
    struct PosterSizes {
        static let DetailPoster = "w500"
    }
    
    // MARK: Filters
    struct MovieFilters {
        static let Ratings = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        static let Certifications = ["Any", "G", "PG", "PG-13", "R", "NC-17"]
        static let Genres = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama",
                             "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction",
                             "TV Movie", "Thriller", "War", "Western"]
    }
}
