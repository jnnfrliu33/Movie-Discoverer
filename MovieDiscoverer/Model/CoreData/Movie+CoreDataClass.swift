//
//  Movie+CoreDataClass.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//
//

import Foundation
import CoreData

// MARK: - Movie: NSManagedObject

public class Movie: NSManagedObject {
    
    convenience init(title: String, releaseDate: String, rating: Double, genre: String, synopsis: String, poster: NSData, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context) {
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.releaseDate = releaseDate
            self.rating = rating
            self.genre = genre
            self.synopsis = synopsis
            self.poster = poster
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
