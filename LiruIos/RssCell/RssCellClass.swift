//
//  RssCellClass.swift
//  LiruIos
//
//  Created by Артем Солохин on 28.02.2022.
//

import UIKit
import WebKit

class RssCell:UITableViewCell {
    
    @IBOutlet weak var CommentButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var Header: UILabel!
}
