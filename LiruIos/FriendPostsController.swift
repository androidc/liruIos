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
        tableView.rowHeight = 600
        
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
        var desc:String = (post?.description)!
        // пакетная загрузка глючит если грузить с mac os, в img alt вставляет какую-то
          // хню. из-за этого desc_enc = nil. нужно очищать <img alt...
          // alt=\"Р РЋР Р…Р С‘Р СР С•Р С” РЎРЊР С”РЎР‚Р В°Р Р…Р В° 2022-04-29 Р Р† 16.10.15 (302x700, 98Kb)\"
        desc.removingRegexMatches(pattern: "alt=\\\"(.+?)\"",replaceWith: "")
        print(desc)
        
        let desc_enc = desc.data(using: String.Encoding.win1251)
   
       let desc_utf = NSString(data:desc_enc ?? Data(),encoding: String.Encoding.utf8.rawValue) as String?
//        print(desc_utf?.win1251Encoded)
      //  cell?.webView.loadHTMLString(posts?.channel?.item![indexPath.row].description.win1251EncodedWithSpace.removingPercentEncoding ?? "", baseURL: URL(string: (post?.link)!))
        
        if  let comments = post?.comments {
            cell?.configure(with: "\(Texts.comment)(\(comments))",link:(post?.link)!,header: (post?.title)!,desc: desc_utf ?? "")
           // cell?.CommentButton.titleLabel?.text = "Комментировать(\(comments))"
        } else
        {   cell?.configure(with: "\(Texts.comment)(0)",link:(post?.link)!,header: (post?.title)!,desc: desc_utf ?? "")
           // cell?.CommentButton.titleLabel?.text = "Комментировать(0)"
        }
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes'></head>"
        
        cell?.webView.loadHTMLString(headerString+(desc_utf?.HTMLImageCorrector())!, baseURL: nil)
        
        cell?.delegate = self
        

       
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
    
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
           do {
               let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
               let range = NSRange(location: 0, length: self.count)
               self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
           } catch { return }
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
    
    func didTabOpenButton(with link: String, header: String, description: String) {
        //selpvc
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selpvc") as! SelectedPostViewController
        
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.bbusername = self.bbusername
        nextViewController.bbuserid = self.bbuserid
        nextViewController.bbusername = self.bbusername
            nextViewController.bbpassword = self.bbpassword
        nextViewController.jurl = self.jurl
        nextViewController.link = link
        nextViewController.postHeader = header
        nextViewController.desc = description
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
}


extension String {

func HTMLImageCorrector() -> String {
    var HTMLToBeReturned = self
    while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
        if let match = HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) {
            HTMLToBeReturned.removeSubrange(match)
            if let match2 = HTMLToBeReturned.range(of: "(?<=height=\")[^\"]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match2)
                let string2del = "width=\"\" height=\"\""
                HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of: string2del, with: "style=\"width: 100%\"")
            }
        }

    }

    return HTMLToBeReturned
}
}
