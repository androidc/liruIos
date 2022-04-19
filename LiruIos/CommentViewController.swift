//
//  CommentViewController.swift
//  LiruIos
//
//  Created by Артем Солохин on 21.03.2022.
//

import Foundation
import UIKit
import XMLMapper

class CommentViewController: UIViewController {
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    var link = ""
    var jid = ""
    var pid = ""
    var posts:RSS?
    var rssString = ""
    var ctitle = ""
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendComment(_ sender: Any) {
    }
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
//    private func GetRssWithCompletion(url:URL,completion: @escaping(_ rssString:String) -> ()) {
//
//        let session = URLSession.shared
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
//        // Form URL-Encoded Body
//        let cookieString = "chbx=guest; jurl=\(jurl);ucss=normal; bbuserid=\(bbuserid); bbpassword=\(bbpassword); bbusername=\(bbusername)"
//        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
//
//        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            DispatchQueue.main.async {
//
//            if (error == nil) {
//                // Success
//                let statusCode = (response as! HTTPURLResponse).statusCode
//               // print("URL Session Task Succeeded: HTTP \(statusCode)")
//                if statusCode == 200 {
//                    let responseString = NSString(data: data!, encoding: String.Encoding.win1251.rawValue)
//
//                    completion(responseString! as String)
//                }
//
//
//
//              }
//              else {
//                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
//              }}
//            })
//        task.resume()
//
//
//
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
          //  make.centerY.equalTo(view.snp.centerY)
          //  make.centerX.equalTo(view.snp.centerY)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.bottom).inset(60)
        }
      //  print("CCCCCCCCCCC")
        print(rssString)
        
        self.posts = XMLMapper<RSS>().map(XMLString: rssString.replacingOccurrences(of: "И", with: "и"))
        let header_enc = posts?.channel?.title?.data(using: String.Encoding.win1251)
        let _title = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
        
       
       // print("ZZZZ")
        navTitle.title = _title
        //print(_title)
       
       // navTitle.title = _title
//        let _link = "\(link)rss"
//        print("AAAAAAAAA")
//        print(_link)
//        activityIndicator.startAnimating()
//        GetRssWithCompletion(url: URL(string: _link)!) { rssString in
//            print("BBBBBBBB")
//            print(rssString)
//            self.posts = XMLMapper<RSS>().map(XMLString: rssString)
//            let header_enc = self.posts?.channel?.title?.data(using: String.Encoding.win1251)
//            let _title = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
//            print("CCCC")
//            print(_title)
//
//            self.navTitle.title = _title
//
//            //print(self.posts?.channel?.title)
//            self.activityIndicator.stopAnimating()
//        }
        
        
    }
}
