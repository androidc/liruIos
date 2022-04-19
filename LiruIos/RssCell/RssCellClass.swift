//
//  RssCellClass.swift
//  LiruIos
//
//  Created by Артем Солохин on 28.02.2022.
//

import UIKit
import WebKit

protocol MyTableViewCellDelegate: AnyObject {
    func didTapButton(with link: String)
}

class RssCell:UITableViewCell {
    
    weak var delegate: MyTableViewCellDelegate?
    
    @IBOutlet weak var CommentButton: UIButton!
    
  
    private var link = ""
    
    @IBAction func didTapButton() {
        print(link)
        delegate?.didTapButton(with: link)
    }
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var Header: UILabel!
    
    func configure(with title: String, link link: String) {
        self.link = link
        CommentButton.setTitle(title, for: .normal)
        
    }
}
