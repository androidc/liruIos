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
         
       
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
            nextViewController.modalPresentationStyle = .fullScreen
           
            self?.present(nextViewController, animated:true, completion:nil)
       
    }
    }
    
    private func UrlSessionLoginWithCompletition(url: URL, completion: () -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        
    }
    
    private func UrlSessionLogin() {
        let session = URLSession.shared
        var URL = URL(string: "https://www.liveinternet.ru/member.php")!
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        
        // Headers
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
              if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                print(response.debugDescription)
                print(HTTPCookieStorage.shared.cookies!)
               
              }
              else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
              }
            })
        task.resume()
        
       
        

    }
    
    private func goToMain(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
        nextViewController.modalPresentationStyle = .fullScreen
       
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func onSignInButton(_ sender: UIButton) {
        // сделать запрос  и получить ответ
       
        if userName.latinCharactersOnly == true {
            
            AFLogin()
        }
        else {
            UrlSessionLogin()
        }

        }
       
        
    
    
}

extension String {
    var latinCharactersOnly: Bool {
        return self.range(of: "\\P{Latin}", options: .regularExpression) == nil
    }
}

