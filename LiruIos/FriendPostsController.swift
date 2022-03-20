//
//  FriendPostsController.swift
//  LiruIos
//
//  Created by Артем Солохин on 28.02.2022.
//
 
import Foundation
import UIKit
import XMLMapper

class FriendPostsController: UIViewController {
    
    var rssString:String = ""
    var nick:String = ""
    var posts:RSS?
    
    let rssCell = "RssCell"
  
   
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
 
    @IBOutlet weak var CustomTitle: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomTitle.title = nick
        
        tableView.dataSource = self
        tableView.rowHeight = 300
        
        // разбор rssString
       print(rssString)
        
        posts = XMLMapper<RSS>().map(XMLString: rssString.replacingOccurrences(of: "И", with: "и").replacingOccurrences(of: "\"//img", with: "\"https://img"))
        
     //   let str = posts?.channel?.item![0].title?.xmlEncodedString
    //    let strr = str?.data(using: String.Encoding.win1251)
     //   print(NSString(data:strr!,encoding: String.Encoding.utf8.rawValue))
        
        
     //   print(posts?.channel?.item![0].description)
     //   let str2 = posts?.channel?.item![0].description.xmlEncodedString
     //   let strr2 = str2?.data(using: String.Encoding.win1251)
      //  print(NSString(data:strr2!,encoding: String.Encoding.utf8.rawValue))
     // print(posts?.channel?.item?[0].title.win1251Encoded.removingPercentEncoding)
     
        tableView.register(UINib(nibName: "RssCell", bundle: nil), forCellReuseIdentifier: rssCell)
        
        
        
    }
}

extension FriendPostsController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts?.channel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rssCell) as? RssCell
        let post = posts?.channel?.item![indexPath.row]
       
        let header_enc = post?.title?.data(using: String.Encoding.win1251)
       
        cell?.Header.text = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
        let desc = post?.description
        let desc_enc = desc?.data(using: String.Encoding.win1251)
       let desc_utf = NSString(data:desc_enc!,encoding: String.Encoding.utf8.rawValue) as String?
//        print(desc_utf?.win1251Encoded)
      //  cell?.webView.loadHTMLString(posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding ?? "", baseURL: URL(string: (post?.link)!))
        
        if  let comments = post?.comments {
            cell?.CommentButton.titleLabel?.text = "Комментировать(\(comments))"
        } else
        {
            cell?.CommentButton.titleLabel?.text = "Комментировать(0)"
        }
        
        cell?.webView.loadHTMLString(desc_utf ?? "", baseURL: nil)
        
    
//        cell?.descriptionTv.text = posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding
    //    print(posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding)
//        print(posts?.channel?.item![indexPath.row].description.win1251Encoded.removingPercentEncoding ?? "")
//        var desc = posts?.channel?.item![indexPath.row].description.win1251Encoded.removingPercentEncoding ?? ""
//        desc = "<!DOCTYPE html><html><body>\(desc.replacingOccurrences(of: "+", with: " "))</body></html>"
//        print(desc)
//        cell?.webView.loadHTMLString(desc, baseURL: nil)
       
        return cell ?? UITableViewCell()
       
    }
    
    
}
