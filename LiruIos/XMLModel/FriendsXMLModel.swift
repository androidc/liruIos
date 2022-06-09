//
//  FriendsXMLModel.swift
//  LiruIos
//
//  Created  on 14.02.2022.
//

import Foundation
import XMLMapper

//<foaf:Person>
//               <foaf:nick>-_Шоколад_-</foaf:nick>
//               <foaf:name>3820577</foaf:name>
//               <foaf:img rdf:resource="http://av.li.ru/577/3820577_17507428.jpg" />
//               <rdfs:seeAlso rdf:resource="https://www.liveinternet.ru/users/3820577/foaf/" />
//<foaf:gender>female</foaf:gender>
//               <foaf:weblog rdf:resource="https://www.liveinternet.ru/users/3820577/" />
//       </foaf:Person>


class Friend:XMLMappable {
    var nodeName: String!
    
    var person: person?

    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        person <- map["foaf:Person"]
      }
    
}

class person:XMLMappable {
    var nodeName: String!
    var knows:[knows]?
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        knows <- map["foaf:knows"]
      }
    
}
    



class knows:XMLMappable {
   
    var nodeName: String!
    var foaf:foaf?
    var Group:foaf_group?
    
    required init?(map: XMLMap) {}
    func mapping(map: XMLMap) {
        foaf <- map["foaf:Person"]
        Group <- map["foaf:Group"]
      }
}


class foaf_group:XMLMappable {
    var nodeName: String!
    
    var nick:String!
    var name:String!
    var weblog:weblog?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        nick <- map["foaf:nick"]
        name <- map["foaf:name"]
        weblog <- map["foaf:weblog"]
      }
    
    
}

class foaf:XMLMappable {
    var nodeName: String!
    
    var nick:String!
    var name:String!
    var weblog:weblog?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        nick <- map["foaf:nick"]
        name <- map["foaf:name"]
        weblog <- map["foaf:weblog"]
      }
    
    
}

class weblog:XMLMappable {
    var nodeName: String!
    var resource:String!
    required init?(map: XMLMap) {}
    func mapping(map: XMLMap) {
        resource <- map.attributes["rdf:resource"]
    }
}


class BooleanTransformeType<T: Equatable>: XMLTransformType {
    typealias Object = Bool
    typealias XML = T

    private var trueValue: T
    private var falseValue: T

    init(trueValue: T, falseValue: T) {
        self.trueValue = trueValue
        self.falseValue = falseValue
    }

    func transformFromXML(_ value: Any?) -> Bool? {
        if let value = value as? T {
            return value == trueValue
        }
        return nil
    }

    func transformToXML(_ value: Bool?) -> T? {
        if value == true {
            return trueValue
        }
        return falseValue
    }
}
