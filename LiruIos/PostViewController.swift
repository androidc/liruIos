//
//  PostViewController.swift
//  LiruIos
//
//  Created
//

import Foundation
import UIKit
import Alamofire
import ImagePicker

class PostViewController: UIViewController{
    
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
    
    @IBAction func OpenImgPickerAction(_ sender: UIButton) {
        
        let config = ImagePickerConfiguration()
         config.doneButtonTitle = "Finish"
         config.noImagesTitle = "Sorry! There are no images here!"
         config.recordLocation = false
        
        let imagePicker = ImagePickerController(configuration: config)
           imagePicker.delegate = self

           present(imagePicker, animated: true, completion: nil)
        
    }
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBAction func TagsTFChanged(_ sender: UITextField) {
        tags = sender.text!
    }
    
    
    @IBAction func IButtonAction(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Подчеркнутый текст", message: "Введите текст", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField!.text)")
            self.TextView.text += "<i>\(textField!.text!)</i>"
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func BButtonAction(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Жирный текст", message: "Введите текст", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField!.text)")
            self.TextView.text += "<b>\(textField!.text!)</b>"
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func MButtonAction(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Убрать под кат", message: "Введите текст", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField!.text)")
            self.TextView.text += "[more=]\(textField!.text!)[/more]"
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func MicroButtonAction(_ sender: UIButton) {
        
        sendMicroPost { status in
           if (status == 200)
            {
               let alert = self.createSuccessMicroAlert()
               self.present(alert, animated: true, completion: nil)
              
           } else {
               
               let alert = self.createErrorAlert()
               self.present(alert, animated: true, completion: nil)
             
           }
        }
    }
    
    @IBAction func SButtonAction(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Зачеркнутый текст", message: "Введите текст", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField!.text)")
            self.TextView.text += "<s>\(textField!.text!)</s>"
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
    
    private func sendMicroPost(url: URL,completion: @escaping (_ status:Int) -> ()) {
        
       
        
        
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
    
    private func createSuccessMicroAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Успех",
            message: "Успешно отправлено в микроблог",
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


    

    private func sendMicroPost(completion: @escaping (_ status:Int) -> ()) {
        
        let requestURL:String = "https://www.liveinternet.ru/microblog.php?cmd=post";
        
        var parameters:Dictionary = [
            "text":TextView.text as! String,
            "encode":"utf"
        ]
        
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
        ).response { [weak self] response in
         completion(response.response?.statusCode ?? 500)
            
        }
        
    }
    
    private func getImgUrl(names:[String]) {
        

        
        let requestURL:String = "http://www.liveinternet.ru/journal_proc.php"
        var headers:HTTPHeaders = [
        "Content-type":"application/x-www-form-urlencoded; charset=UTF-8"]
        headers["Accept"] = "*/*"
        headers["User-Agent"] = "Mozilla/5.0 (Windows NT 5.1)"
        headers["Cookie"] = "li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername
        headers["Referer"] = "http://www.liveinternet.ru/journal_post.php?journalid=\(bbuserid)"
        headers["Accept-Encoding"] = "gzip,deflate,sdcn"
        headers["Accept-Language"] = "ru,en;q=0.8"
        headers["X-Requested-With"] = "XMLHttpRequest"
        
        var parameters:Dictionary = [
            "action":"parse_plup_images"]
        
        for (index,name) in names.enumerated() {
            parameters["uploader_\(index)_name"] = name
            parameters["uploader_\(index)_tmpname"] = name
            parameters["uploader_\(index)_status"] = "done"
           // print(name)
           // print(index)
        }
        
        AF.request(
            requestURL,
            method: .post,
            parameters: parameters,
            headers: headers
        ).response  { [weak self] response in
            //print(response.debugDescription)
            if let data = response.data {
                var json = String(data:data,encoding: .utf8)
                json = json?.replacingOccurrences(of: "{\"images_code\":\"", with: "")
                json = json?.replacingOccurrences(of: "\"}", with: "")
                json = json?.replacingOccurrences(of: "\\\\", with: "")
                json = json?.replacingOccurrences(of: "\\", with: "")
                
                self?.TextView.text += json ?? ""
            }
            
            
            
        }
        
    
        
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
           // print(response.debugDescription)
          //  print(HTTPCookieStorage.shared.cookies!)
            
        }
            
            
        
             
        
        
               
                
                
        
    }
    
    // activityIndicator.startAnimating()
    //activityIndicator.stopAnimating()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(bbuserid)
//        print(bbpassword)
//        print(bbusername)
//        print(jurl)
//

        pickerData = ["как и весь дневник", "закрыт неавторизованным", "закрыт всем кроме друзей и ПЧ", "закрыт всем, кроме хозяина дневника","закрыт всем, кроме избранных"]
        
        
        
        // Connect data:
              self.picker.delegate = self
              self.picker.dataSource = self
        
        view.addSubview(activityIndicator)
       
    }
    
    
    
}

extension PostViewController: ImagePickerDelegate {
  
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
       imagePicker.dismiss(animated: true, completion: nil)
     }

     func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        /*
       guard images.count > 0 else { return }
       let lightboxImages = images.map {
         return LightboxImage(image: $0)
       }
       let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
       imagePicker.present(lightbox, animated: true, completion: nil)
        */
     }
    
    /* this func not used, for code example*/
    func createRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
           let lineBreak = "\r\n"
           var requestBody = Data()

           requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
           requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
           requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
           requestBody.append(imageData)
           requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)

           return requestBody
       }

     func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
       
     //    print("selected images count:\(images.count)")
         let url =  "https://www.liveinternet.ru/uploader/upload.php"
         let lineBreak = "\r\n"
         var urlRequest = URLRequest(url: URL(string: url)!)
         
         urlRequest.httpMethod = "post"
         urlRequest.addValue("li-plug_top=closed; chbx=guest; jurl=" + jurl + "; ucss=normal; bbuserid=" + bbuserid + "; bbpassword=" + bbpassword + "; bbusername=" + bbusername, forHTTPHeaderField: "Cookie")
         urlRequest.addValue("https://liveinternet.ru/journal_post.php?journalid="+bbuserid, forHTTPHeaderField: "Referer")
         urlRequest.addValue("gzip,deflate,sdcn", forHTTPHeaderField: "Accept-Encoding")
         urlRequest.addValue("ru,en;q=0.8", forHTTPHeaderField: "Accept-Language")
         urlRequest.addValue("Mozilla/5.0 (Windows NT 5.1)", forHTTPHeaderField: "User-Agent")
         let bodyBoundary = "--------------------------\(UUID().uuidString)"
         urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
         
         var names:[String] = []
         let dispatchGroup = DispatchGroup()
         activityIndicator.startAnimating()
         for img in images {
             let filename = "\(UUID().uuidString)".replacingOccurrences(of: "-", with: "_")
             let filename1 = "\(filename).jpg"
             names.append(filename1)
             var requestBody = Data()
           //  let tmpname = "tmp_ddd\(i).jpg"
             
             //print(filename1)
             
              let imageData = img.jpegData(compressionQuality: 0.9)
             //let imageData = img.pngData()
             requestBody.append("\(lineBreak)--\(bodyBoundary + lineBreak)" .data(using: .utf8)!)
             requestBody.append("Content-Disposition: form-data; name=\"name\"; \(lineBreak)" .data(using: .utf8)!)
             requestBody.append("\(lineBreak)\(lineBreak)\(filename1)\(lineBreak)" .data(using: .utf8)!)
             
             requestBody.append("\(lineBreak)--\(bodyBoundary + lineBreak)" .data(using: .utf8)!)
             requestBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename1)\"\(lineBreak)" .data(using: .utf8)!)
             requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
             requestBody.append(imageData!)
             //requestBody.append("\(lineBreak)--\(bodyBoundary + lineBreak)" .data(using: .utf8)!)
             //requestBody.append(lineBreak .data(using: .utf8)!)
             requestBody.append("\(lineBreak)--\(bodyBoundary)--\(lineBreak)" .data(using: .utf8)!)
             
             urlRequest.httpBody = requestBody
             urlRequest.addValue("\(requestBody.count)", forHTTPHeaderField: "content-length")
             dispatchGroup.enter()
             URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

                       if(error == nil && data != nil && data?.count != 0){
                         //  print(httpUrlResponse?.description)
                           
                           print("its work \(filename1)")
                           dispatchGroup.leave()
                           
                       }
                   }.resume()
           
         }
       
         dispatchGroup.notify(queue: DispatchQueue.main) {
             self.activityIndicator.stopAnimating()
             self.getImgUrl(names: names)
             
             //print("all done")
         }
         
         
       
         
         
         imagePicker.dismiss(animated: true, completion: nil)
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


