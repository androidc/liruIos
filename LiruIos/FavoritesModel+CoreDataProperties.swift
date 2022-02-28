//
//  FavoritesModel+CoreDataProperties.swift
//  
//
//  Created by Артем Солохин on 23.02.2022.
//
//

import Foundation
import CoreData


extension FavoritesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesModel> {
        return NSFetchRequest<FavoritesModel>(entityName: "FavoritesModel")
    }

    @NSManaged public var bbuserid: String?
    @NSManaged public var name: String?
    @NSManaged public var nick: String?
    @NSManaged public var url: String?

}
