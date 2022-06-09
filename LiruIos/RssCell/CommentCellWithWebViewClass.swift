//
//  CommentCellWithWebViewClass.swift
//  LiruIos
//
//  Created
//

import Foundation
import UIKit
import WebKit

class CommentCellWithWebView:UITableViewCell {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var Header: UITextView!
    
    
    @IBOutlet weak var Author: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()

    //textFieldCell.layer.borderColor = UIColor.orange.cgColor
    self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemBlue.cgColor
        
    

    }
    
    
}
