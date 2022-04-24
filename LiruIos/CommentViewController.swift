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
    var postHeader = ""
    var selectedComment = ""

    
    let commentCell = "CommentCell"
    let commentCellWithWebView = "CommentCellWithWebView"
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
       // sendComment(from: posts!)
        sendCommentCP1251(source: posts!, url: URL(string: "http://www.liveinternet.ru/journal_addcomment.php?action=newcomment&doajax=1")!) { status in
            if status == 200 {
                let alert = self.createSuccessAlert()
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerInput: UITextField!
    
    @IBOutlet weak var messageInput: UITextView!
    
    
    
    private func createSuccessAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Успех",
            message: "Успешно отправлено в дневник",
            preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"ok",style:.destructive,handler: nil))
            
            return alert
        }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    private func getJid(_ link:String) -> String? {
        let link_components = link.components(separatedBy: "/")
        let img_components = link_components.last?.components(separatedBy: "_")
        return img_components![0]
    }
    
    private func getPid(_ link:String) -> String? {
        let link_components = link.components(separatedBy: "/")
        let postlink = link_components[link_components.endIndex-2]
        return postlink.replacingOccurrences(of: "post", with: "")
    }
    
    private func getCommid(_ link:String) -> String? {
        let link_components = link.components(separatedBy: "/")
        let commlink = link_components.last!
        return commlink.replacingOccurrences(of: "#BlCom", with: "")
    }
    
    // необходимые данные для комментария
    // journalid : channel - image - url
    // из линка к изображению часто до _ 3180039_11871669.png -> 3180039
    // jpostid: channel - link (post473516325/ -> 473516325
    // jcommid: #BlCom703472240 или 703472240
    // commentsubscribe: "yes"
    // isshow - 0, 1 - скрыть комментарий ? (пока 0, todo)
    // dopostlink - 0
    // dolike - 0, 1 - поставить лайк (пока 0, todo )
    // parseurl - yes
    // close_level - 0
    
    // message - текст комментария
    private func sendCommentCP1251(source: RSS, url: URL,completion: @escaping (_ status:Int) -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        
        request.addValue("li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername, forHTTPHeaderField: "Cookie")
        
        print("li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername)
        
        
        request.addValue("http://www.liveinternet.ru/users/" + bbusername + "/blog/", forHTTPHeaderField: "Referer")
        
        request.addValue("gzip,deflate,sdcn", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("ru,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.addValue("Mozilla/5.0 (Windows NT 5.1)", forHTTPHeaderField: "User-Agent")
        
        
        guard let jid = getJid((source.channel?.image?.img_url)!) else {
            return
        }
        
        guard let pid = getPid((source.channel?.link)!) else {
            return
        }
        
        var commID = ""
        if selectedComment != "" {
            guard let commId = getCommid(selectedComment) else {
                return
            }
            commID = commId
        }
        
        var parameters:Dictionary = [
            "journalid":jid,
            "jpostid":pid,
            "jcommid": commID,
            "commentsubscribe":"yes", // todo
            "isshow":"0",
            "dopostlink":"0",
            "dolike":"0", // todo
            "parseurl":"yes",
            "close_level":"0",
            "headerofpost": headerInput.text as! String,
            "message":messageInput.text as! String
        ]
        
        let bodyString = parameters.queryParameters
        request.httpBody = bodyString.data(using: .win1251, allowLossyConversion: true)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
           
             
                print("URL Session Task Succeeded: HTTP \(statusCode)")
        
                
             
                
                completion(statusCode)
         
               
                
//                //print(HTTPCookieStorage.shared.cookies!)
//                if (!response.debugDescription.contains("error_register")) {
//                    completion("OK")
//                }
//                else
//                { completion("Error") }
            
              }
              else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
                  completion(500)
              }}
            })
        task.resume()
        
        
    
        
        
        
        
        
        
        
        
    }
    

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
        
        if (self.link == posts?.channel?.link) {
            // значит получили правильный rss и можно заполнять данные
            let header_enc = posts?.channel?.title?.data(using: String.Encoding.win1251)
            let _title = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
                 navTitle.title = _title
            tableView.rowHeight = 200
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "CommentCellWithWebView", bundle: nil), forCellReuseIdentifier: commentCellWithWebView)
           // tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: commentCell)
          //  tableView.register(UINib(nibName: "CommentCellWithWebView", bundle: nil), forCellReuseIdentifier: commentCellWithWebView)
            
        } else
        {
            
            
            let navTitleData = postHeader.data(using: String.Encoding.win1251)
            
            navTitle.title = NSString(data:navTitleData!,encoding: String.Encoding.utf8.rawValue) as String?
        }
       
        
    }
    
  
}

extension CommentViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts?.channel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellWithWebView) as? CommentCellWithWebView
        let post = posts?.channel?.item![indexPath.row]
       
        let header_enc = post?.description?.data(using: String.Encoding.win1251)
        
        
        let desc_enc = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as! String
        
        let author_enc = post?.author.data(using: String.Encoding.win1251)
        
        
        cell?.Author.text = NSString(data:author_enc!,encoding: String.Encoding.utf8.rawValue) as! String
        
        
    
        let textArr = desc_enc.components(separatedBy: "|")
        
        cell?.Header.text = textArr[0]
        //cell?.Comment.text = textArr[1]
        cell?.webView.loadHTMLString(textArr[1] ?? "", baseURL: nil)
       
//        cell?.Header.text = NSString(data:header_enc!,encoding: String.Encoding.utf8.rawValue) as String?
//        let desc = post?.description
//        let desc_enc = desc?.data(using: String.Encoding.win1251)
//       let desc_utf = NSString(data:desc_enc!,encoding: String.Encoding.utf8.rawValue) as String?


        return cell ?? UITableViewCell()
       
    }
    
    // метод обрабатывающий нажатие на ячейку
     func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath) {
         let post = posts?.channel?.item![indexPath.row]
         selectedComment = post?.link ?? ""
         
      
     }
    
}
