//
//  SendPostViewController.swift
//  LiruIos
//
//  Created by Артем Солохин on 27.01.2022.
//

import Foundation
import UIKit

class SendPostViewController: UIViewController {
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    var username=""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // print("bbuserid:\(bbuserid)")
        uNameField.text = username
       
    }
    
    @IBOutlet weak var uNameField: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if let nextViewController = segue.destination as? SecondViewController {
//                       nextViewController.shouldBehavesAsLogin = isLoginTapped
//                   }
        
        if let postVC = segue.destination as? PostViewController {
            postVC.bbuserid = bbuserid
            postVC.bbpassword = bbpassword
            postVC.bbusername = bbusername
            postVC.jurl = jurl
        }
        
        if let friendsVC = segue.destination as? FriendsListController {
            friendsVC.bbuserid = bbuserid
            friendsVC.bbpassword = bbpassword
            friendsVC.bbusername = bbusername
            friendsVC.jurl = jurl
        }
        
        if let favoritesVC = segue.destination as?
        FavoritesListController {
            favoritesVC.bbuserid = bbuserid
            favoritesVC.bbpassword = bbpassword
            favoritesVC.bbusername = bbusername
            favoritesVC.jurl = jurl
        }
        
//        if segue.destination == PostViewController {
//            let postVC:PostViewController = segue.destination as! PostViewController
//            postVC.bbuserid = bbuserid
//            postVC.bbpassword = bbpassword
//            postVC.bbusername = bbusername
//            postVC.jurl = jurl
//        }
       
        
    }
    
 
    private func formatJurl(jurl: String) -> String {
       return jurl.replacingOccurrences(of: "%3A", with: ":")
            .replacingOccurrences(of: "%2F", with: "/")
    }
    
    private func GetRssWithCompletion(url:URL,completion: @escaping(_ rssString:String) -> ()) {
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        // Form URL-Encoded Body
        let cookieString = "chbx=guest; jurl=\(jurl);ucss=normal; bbuserid=\(bbuserid); bbpassword=\(bbpassword); bbusername=\(bbusername)"
        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
               // print("URL Session Task Succeeded: HTTP \(statusCode)")
                if statusCode == 200 {
                    let responseString = NSString(data: data!, encoding: String.Encoding.win1251.rawValue)
                   
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

    @IBAction func myBlogOpen(_ sender: Any) {
       //  print(jurl)
        let rssUlr = "\(formatJurl(jurl: jurl))/rss"
        GetRssWithCompletion(url: URL(string: rssUlr)!) { rssString in
           // print(rssString)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fpvc") as! FriendPostsController
            nextViewController.modalPresentationStyle = .fullScreen
                nextViewController.rssString = rssString
            
           
            nextViewController.nick = self.username
            nextViewController.isMyBlog = true
            
            nextViewController.bbuserid = self.bbuserid
            nextViewController.bbusername = self.bbusername
            nextViewController.bbpassword = self.bbpassword
            nextViewController.jurl = self.jurl
          
            
            self.present(nextViewController, animated: true)
            
            
            
        }
        
    }
    
    @IBAction func friendsOpen(_ sender: Any) {
        let rssUlr = "\(formatJurl(jurl: jurl))/friends/rss"
        GetRssWithCompletion(url: URL(string: rssUlr)!) { rssString in
           // print(rssString)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fpvc") as! FriendPostsController
            nextViewController.modalPresentationStyle = .fullScreen
                nextViewController.rssString = rssString
            
           
            nextViewController.nick = "Лента друзей"
            nextViewController.isMyBlog = false
            
            nextViewController.bbuserid = self.bbuserid
            nextViewController.bbusername = self.bbusername
            nextViewController.bbpassword = self.bbpassword
            nextViewController.jurl = self.jurl
            
            self.present(nextViewController, animated: true)
            
            
            
        }
    }
    
    @IBAction func ChangeUserButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "lgvc") as! ViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.changeUserFlag = true
        
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    private func SetupViews() {
     
        
    }
    
  
    
}
