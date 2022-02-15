//
//  PostViewController.swift
//  LiruIos
//
//  Created by Артем Солохин on 30.01.2022.
//

import Foundation
import UIKit
import Alamofire

class PostViewController: UIViewController {
    
    private var header: String = ""
    private var tags: String = ""
    var selectedRowInPicker = 0
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    
    var pickerData: [String] = [String]()
    
    @IBAction func HeaderTFChanged(_ sender: UITextField) {
        header = sender.text!
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBAction func TagsTFChanged(_ sender: UITextField) {
        tags = sender.text!
    }
    
    
    @IBAction func onDraftButton(_ sender: Any) {
        sendPostCP1251(url:URL(string: "http://www.liveinternet.ru/journal_addpost.php?doajax=1")!,draft: true, completion: {status,draft in
            if status == 200 {
                if draft == true {
                    let alert = self.createDraftSuccessAlert()
                            self.present(alert, animated: true, completion: nil)
                  } else
                {
                      let alert = self.createSuccessAlert()
                      self.present(alert, animated: true, completion: nil)
                        
                    }
            }
            else {
                let alert = self.createErrorAlert()
                self.present(alert, animated: true, completion: nil)
                
            }
        })
        
   
    }
    
    @IBAction func SendButton(_ sender: Any) {
        
      //sendPost(draft: false)
        sendPostCP1251(url:URL(string: "http://www.liveinternet.ru/journal_addpost.php?doajax=1")!,draft: false, completion: {status,draft in
            if status == 200 {
                if draft == true {
                    let alert = self.createDraftSuccessAlert()
                           self.present(alert, animated: true, completion: nil)
                   } else
                {
                       let alert = self.createSuccessAlert()
                       self.present(alert, animated: true, completion: nil)
                    }
            }
            else {
                let alert = self.createErrorAlert()
                self.present(alert, animated: true, completion: nil)
                
            }
        })
        
   
        
    }
    
    private func sendPostCP1251(url: URL,draft:Bool, completion: @escaping (_ status:Int,_ draft: Bool) -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        request.addValue("li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername, forHTTPHeaderField: "Cookie")
        request.addValue("http://www.liveinternet.ru/users/" + bbusername + "/blog/", forHTTPHeaderField: "Referer")
        
        request.addValue("gzip,deflate,sdcn", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("ru,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.addValue("Mozilla/5.0 (Windows NT 5.1)", forHTTPHeaderField: "User-Agent")
        
        var bodyParameters = [
            "action":"newpost",
            "autosave_postid":"0",
            "journalid": bbuserid,
            "make_br_sel":"yes",
            "commentsubscribe":"yes",
            "parseurl":"yes",
         
        ]
        
        switch selectedRowInPicker {
        case 0:
            bodyParameters["close_level"] = "0"
        case 1:
            bodyParameters["close_level"] = "1"
        case 2:
            bodyParameters["close_level"] = "7"
        case 3:
            bodyParameters["close_level"] = "6"
        case 4:
            bodyParameters["close_level"] = "4"
        default:
            bodyParameters["close_level"] = "0"
        }
        if (draft == true) {
            bodyParameters["draft"]=" В черновик "}
        bodyParameters["headerofpost"] = header
        bodyParameters["message"] = TextView.text!
        bodyParameters["tags"] = tags
        
        let bodyString = bodyParameters.queryParameters
        request.httpBody = bodyString.data(using: .win1251, allowLossyConversion: true)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
           
             
                print("URL Session Task Succeeded: HTTP \(statusCode)")
        
                
             
                
                completion(statusCode,draft)
         
               
                
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
                  completion(500,draft)
              }}
            })
        task.resume()
        
        
    
        
    }
    
    
    private func createErrorAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Ошибка отправки",
            message: "Попробуйте позже",
            preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"ok",style:.destructive,handler: nil))
            
            return alert
        }
    
    private func createSuccessAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Успех",
            message: "Успешно отправлено в дневник",
            preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"ok",style:.destructive,handler: nil))
            
            return alert
        }
    
    private func createDraftSuccessAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Успех",
            message: "Успешно отправлено в черновик",
            preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"ok",style:.destructive,handler: nil))
            
            return alert
        }


    

    
    
    private func sendPost(draft:Bool) {
        
        let requestURL:String = "http://www.liveinternet.ru/journal_addpost.php?doajax=1";
            
            var parameters:Dictionary = [
                "action":"newpost",
                "autosave_postid":"0",
                "journalid": bbuserid,
                "make_br_sel":"yes",
                "commentsubscribe":"yes",
                "parseurl":"yes",
            ]
    
            
            switch selectedRowInPicker {
            case 0:
                parameters["close_level"] = "0"
            case 1:
                parameters["close_level"] = "1"
            case 2:
                parameters["close_level"] = "7"
            case 3:
                parameters["close_level"] = "6"
            case 4:
                parameters["close_level"] = "4"
            default:
                parameters["close_level"] = "0"
            }
            
            if (draft == true) {
                parameters["draft"]=" В черновик "}
           
            
        parameters["headerofpost"] = header
        parameters["message"] = TextView.text!
        parameters["tags"] = tags
        
            var headers:HTTPHeaders = [
            "Content-type":"application/x-www-form-urlencoded;charset=win-1251"]
            headers["Cookie"] = "li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername
            headers["Referer"] = "http://www.liveinternet.ru/users/" + bbusername + "/blog/"
            headers["Accept-Encoding"] = "gzip,deflate,sdcn"
            headers["Accept-Language"] = "ru,en;q=0.8"
            headers["User-Agent"] = "Mozilla/5.0 (Windows NT 5.1)"
        
        AF.request(
            requestURL,
            method: .post,
            parameters: parameters,
            headers: headers
        ).response  { [weak self] response in
            print(response.debugDescription)
            print(HTTPCookieStorage.shared.cookies!)
            
        }
            
            
        
             
        
        
               
                
                
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   

        pickerData = ["как и весь дневник", "закрыт неавторизованным", "закрыт всем кроме друзей и ПЧ", "закрыт всем, кроме хозяина дневника","закрыт всем, кроме избранных"]
        
        
        
        // Connect data:
              self.picker.delegate = self
              self.picker.dataSource = self
       
    }
    
    
    
}

extension PostViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
       }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 14)
        label.text =  pickerData[row]
        label.textAlignment = .center
        return label
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         
           // This method is triggered whenever the user makes a change to the picker selection.
           // The parameter named row and component represents what was selected.
        self.selectedRowInPicker = row
           
       }
    
    
}


