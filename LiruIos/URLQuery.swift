//
//  URLQuery.swift
//  LiruIos
//
//  Created on 29.01.2022.
//

import Foundation

protocol URLQueryParameterStringConvertible {
  var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
  var queryParameters: String {
    var parts: [String] = []
    for (key, value) in self {
        

if ( String(describing: key) == "password") {
     let part = String(format: "%@=%@",
                        String(describing: key).win1251Encoded,
                       String(describing: value).win1251Encoded.replacingOccurrences(of: "&", with: "%26"))
            parts.append(part as String)
        }
        else
        { let part = String(format: "%@=%@",
                            String(describing: key).win1251Encoded,
                            String(describing: value).win1251Encoded)
           parts.append(part as String)
        }
        
      
    }
      
    return parts.joined(separator: "&")
  }
  
}

extension String.Encoding {
  static let win1251 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsCyrillic.rawValue)))
}


extension CharacterSet {
  static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~=&+")
}



extension String {
  func addingPercentEncoding(withAllowedCharacters characterSet: CharacterSet, using encoding: String.Encoding) -> String {
    let stringData = self.data(using: encoding, allowLossyConversion: true) ?? Data()
    let percentEscaped = stringData.map {byte->String in
      if characterSet.contains(UnicodeScalar(byte)) {
        return String(UnicodeScalar(byte))
      } else if byte == UInt8(ascii: " ") {
        return "+"
      } else {
        return String(format: "%%%02X", byte)
      }
      }.joined()
    return percentEscaped
  }
  
  var win1251Encoded: String {
    return self.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved,  using: . win1251)
  }
}
