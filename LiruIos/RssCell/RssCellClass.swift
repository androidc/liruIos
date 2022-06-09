//
//  RssCellClass.swift
//  LiruIos
//
//  Created  on 28.02.2022.
//

import UIKit
import WebKit

protocol MyTableViewCellDelegate: AnyObject {
    func didTapButton(with link: String,header: String)
    func didTabOpenButton(with link: String, header: String, description: String)
}

class RssCell:UITableViewCell {
    
    weak var delegate: MyTableViewCellDelegate?
    
    @IBOutlet weak var CommentButton: UIButton!
    
    @IBOutlet weak var OpenButton: UIButton!
    
    private var link = ""
    private var header = ""
    private var desc = ""
    
    @IBAction func didTapOpenButton() {
        delegate?.didTabOpenButton(with: link, header: header, description: desc)
    }
    @IBAction func didTapButton() {
        print(link)
        delegate?.didTapButton(with: link, header: header)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var Header: UILabel!
    
    func configure(with title: String, link: String, header: String, desc: String) {
        self.link = link
        self.header = header
        self.desc = desc
        CommentButton.setTitle(title, for: .normal)
        
    }
}
