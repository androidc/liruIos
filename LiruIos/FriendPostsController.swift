//
//  FriendPostsController.swift
//  LiruIos
//
//  Created by Артем Солохин on 28.02.2022.
//
 

import UIKit
import XMLMapper

class FriendPostsController: UIViewController {
    
    var rssString:String = ""
    var nick:String = ""
    var posts:RSS?
    var comments:RSS?
    var isMyBlog:Bool = false
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    
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
       //print(rssString)
        
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
    
    private func getPid(postlink:String)->String {
        
        let linkArr = postlink.components(separatedBy: "/")
        
        
        if postlink.contains("www.liveinternet.ru") {
            return linkArr[5]
        }
        return linkArr[3]
    }
    

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
            cell?.configure(with: "Комментировать(\(comments))",link:(post?.link)!,header: (post?.title)!)
           // cell?.CommentButton.titleLabel?.text = "Комментировать(\(comments))"
        } else
        {   cell?.configure(with: "Комментировать(0)",link:(post?.link)!,header: (post?.title)!)
           // cell?.CommentButton.titleLabel?.text = "Комментировать(0)"
        }
        
        cell?.webView.loadHTMLString(desc_utf ?? "", baseURL: nil)
        
        cell?.delegate = self
        
 
       // Optional("https://www.liveinternet.ru/users/2125404/post491267365/")
      //  Optional("https://www.liveinternet.ru/users/chert/post491267390/")
        
        // try jid = 2125404 or chert
        // try pid = 491267390
     
//        cell?.CommentButton.addAction(UIAction(title: "",  handler: {action in
//
//            print(post?.link)
           
            // добавить вызов контроллера с передачей всех необходимых данных для
            // комментирования
            //print(post?.link)
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cmvc") as! CommentViewController
//            nextViewController.modalPresentationStyle = .fullScreen
//            nextViewController.bbusername = self.bbusername
//            nextViewController.bbuserid = self.bbuserid
//            nextViewController.bbusername = self.bbusername
//            nextViewController.jurl = self.jurl
//
//            let link = (post?.link)!
//
//            self.GetRssWithCompletion(url: URL(string: "\(link)rss")!) { rssCommentString in
//
//                nextViewController.rssString = rssCommentString
//
//                self.present(nextViewController, animated:true, completion:nil)
//            }
            
            
            
//
//        }), for: .touchUpInside)
//
    
//        cell?.descriptionTv.text = posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding
    //    print(posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding)
//        print(posts?.channel?.item![indexPath.row].description.win1251Encoded.removingPercentEncoding ?? "")
//        var desc = posts?.channel?.item![indexPath.row].description.win1251Encoded.removingPercentEncoding ?? ""
//        desc = "<!DOCTYPE html><html><body>\(desc.replacingOccurrences(of: "+", with: " "))</body></html>"
//        print(desc)
//        cell?.webView.loadHTMLString(desc, baseURL: nil)
       
        return cell ?? UITableViewCell()
       
    }
    
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

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension FriendPostsController: MyTableViewCellDelegate {
    func didTapButton(with link: String, header: String) {
       //print(link)
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
            nextViewController.link = link
            nextViewController.postHeader = header
            //
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        
    }
    
    
}
