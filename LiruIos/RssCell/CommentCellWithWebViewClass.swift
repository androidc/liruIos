//
//  CommentCellWithWebViewClass.swift
//  LiruIos
//
//  Created by Артем Солохин on 24.04.2022.
//

import Foundation
import UIKit
import WebKit

class CommentCellWithWebView:UITableViewCell {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var Header: UITextView!
    
    
    @IBOutlet weak var Author: UILabel!
    
    
    
}
