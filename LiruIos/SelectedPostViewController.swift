//
//  SelectedPostViewController.swift
//  LiruIos
//
//  Created by Артем Солохин on 29.04.2022.
//

import Foundation
import UIKit
import WebKit

class SelectedPostViewController: UIViewController {
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    var link = ""
    var postHeader = ""
    var desc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let header_enc = postHeader.data(using: String.Encoding.win1251)
        
        navTitle.title =  NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes'></head>"
        
        webView.loadHTMLString(headerString+(desc.HTMLImageCorrector()), baseURL: nil)
        
    }
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func CommentButtonAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cmvc") as! CommentViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.bbusername = self.bbusername
        nextViewController.bbuserid = self.bbuserid
        nextViewController.bbusername = self.bbusername
            nextViewController.bbpassword = self.bbpassword
        nextViewController.jurl = self.jurl
            //print("\(link)rss")
            self.GetRssWithCompletion(url: URL(string: "\(link)rss")!) { rssCommentString in
                nextViewController.rssString = rssCommentString
                nextViewController.link = self.link
                nextViewController.postHeader = self.postHeader
                //
                self.present(nextViewController, animated:true, completion:nil)
            }
    }
    
    
    @IBOutlet weak var webView: WKWebView!
    
    private func GetRssWithCompletion(url:URL,completion: @escaping(_ rssCommentString:String) -> ()) {
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        // Form URL-Encoded Body
        let cookieString = "chbx=guest; jurl=\(jurl);ucss=normal; bbuserid=\(bbuserid); bbpassword=\(bbpassword); bbusername=\(bbusername)"
        //print(cookieString)
        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
               // print("URL Session Task Succeeded: HTTP \(statusCode)")
                //print(response.debugDescription)
                if statusCode == 200 {
                    let responseString = NSString(data: data!, encoding: String.Encoding.win1251.rawValue)
                   // print(responseString)
                   
                    completion(responseString! as String)
                }
               
              
            
              }
              else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
              }}
            })
        task.resume()
     
    }
    
    
}
