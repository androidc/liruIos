//
//  ViewController.swift
//  LiruIos
//
//  Created  on 26.01.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private var userName:String = ""
    private var pass:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var PassField: UITextField!
    @IBAction func onPassChanged(_ sender: UITextField) {
        pass = sender.text!
    }
    
    @IBAction func onLoginChanged(_ sender: UITextField) {
        userName = sender.text!
    }
    
    private func AFLogin() {
        
        let parameters = ["username":userName,"password":pass,
                       "action":"login"]
        
        AF.request(
            "https://www.liveinternet.ru/member.php",
            method: .post,
            parameters: parameters
        ).response { [weak self] response in
            print(response.debugDescription)
            print(HTTPCookieStorage.shared.cookies!)
           
         
            if response.debugDescription.contains("https://www.liveinternet.ru/member.php?rndm=") {
                self?.PassField.text = ""
                let alert = self?.createAlert() ?? UIAlertController()
                self?.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
                nextViewController.modalPresentationStyle = .fullScreen
                
                for cookie in HTTPCookieStorage.shared.cookies! {
                   // print(cookie.name)
                    //print(cookie.value)
                    
                    if cookie.name == "bbusername" {
                        nextViewController.bbusername = cookie.value
                    }
                    if cookie.name == "bbuserid" {
                        nextViewController.bbuserid = cookie.value
                    }
                    if cookie.name == "jurl" {
                        nextViewController.jurl = cookie.value
                    }
                    if cookie.name == "bbpassword" {
                        nextViewController.bbpassword = cookie.value
                    }
                }
                self?.present(nextViewController, animated:true, completion:nil)
           
            }
            
           
    }
    }
    
    private func UrlSessionLoginWithCompletition(url: URL, completion: @escaping (_ status:String) -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        // Form URL-Encoded Body
        let bodyParameters = [
            "action" : "login",
            "password": pass,
            "username": userName
         
        ]
        
        let bodyString = bodyParameters.queryParameters
        request.httpBody = bodyString.data(using: .win1251, allowLossyConversion: true)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
               
                
                print(HTTPCookieStorage.shared.cookies!)
                if (!response.debugDescription.contains("error_register")) {
                    completion("OK")
                }
                else
                { completion("Error") }
            
              }
              else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
              }}
            })
        task.resume()
        

        
        
    }
    
  
    
  
    
    private func createAlert() -> UIAlertController {
            let alert = UIAlertController (
            title: "Ошибка входа",
            message: "Неправильный логин или пароль",
            preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"ok",style:.destructive,handler: nil))
            
            return alert
        }

    
    
    @IBAction func onSignInButton(_ sender: UIButton) {
        // сделать запрос  и получить ответ
       
        if userName.latinCharactersOnly == true {
            
            AFLogin()
        }
        else {
            //UrlSessionLogin()
            UrlSessionLoginWithCompletition(url: URL(string: "https://www.liveinternet.ru/member.php")!, completion: {status in
                
                if status == "OK" {
                    
                    
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
                nextViewController.modalPresentationStyle = .fullScreen
                    
                    for cookie in HTTPCookieStorage.shared.cookies! {
                       // print(cookie.name)
                        //print(cookie.value)
                        
                        if cookie.name == "bbusername" {
                            nextViewController.bbusername = cookie.value
                        }
                        if cookie.name == "bbuserid" {
                            nextViewController.bbuserid = cookie.value
                        }
                        if cookie.name == "jurl" {
                            nextViewController.jurl = cookie.value
                        }
                        if cookie.name == "bbpassword" {
                            nextViewController.bbpassword = cookie.value
                        }
                    }
               
                    self.present(nextViewController, animated:true, completion:nil)}
                else{
                    // показать алерт
                    let alert = self.createAlert() ?? UIAlertController()
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }

        }
       
        
    
    
}

extension String {
    var latinCharactersOnly: Bool {
        return self.range(of: "\\P{Latin}", options: .regularExpression) == nil
    }
}

