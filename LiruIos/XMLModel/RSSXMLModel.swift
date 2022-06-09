//
//  RSSXMLModel.swift
//  LiruIos
//
//  Created  on 28.02.2022.
//

import Foundation
import XMLMapper

class RSS:XMLMappable {
    var nodeName: String!
    
    var channel: channel?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        channel <- map["channel"]
      }
    
    
}

class channel:XMLMappable {
    var nodeName: String!
    
    var title:String!
    var link:String!
    var image:image?
    var item:[item]?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        title <- (map["title"], XMLCDATATransform())
        link <- map["link"]
        image <- map["image"]
        item <- map["item"]
      }
    
    
}

class image:XMLMappable {
    var nodeName: String!
    var img_url:String!
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        img_url <- map["url"]
    }
}

class item:XMLMappable {
    var nodeName: String!
    var title:String!
    var link:String!
    var description:String!
    var category:[String]?
    var author:String!
    var comments:Int?
    
    required init?(map: XMLMap) {}
    func mapping(map: XMLMap) {
        title <- (map["title"], XMLCDATATransform())
        link <- (map["link"], XMLCDATATransform())
        description <- (map["description"], XMLCDATATransform())
        category <- (map["category"], XMLCDATATransform())
        author <- (map["author"], XMLCDATATransform())
        comments <- map["slash:comments"]
    }
    
    
}
