//
//  Friend+CoreDataProperties.swift
//  
//
//  Created by Артем Солохин on 15.02.2022.
//
//

import Foundation
import CoreData


extension FriendModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendModel> {
        return NSFetchRequest<FriendModel>(entityName: "FriendModel")
    }

    @NSManaged public var nick: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var bbuserid: String?
   
  
}
