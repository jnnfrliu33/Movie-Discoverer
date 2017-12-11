//
//  Movie+CoreDataProperties.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var genre: String?
    @NSManaged public var rating: Double
    @NSManaged public var synopsis: String?
    @NSManaged public var poster: NSData?

}
