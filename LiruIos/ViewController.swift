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
    var changeUserFlag:Bool = false
    
    private var ud_userName:String? = nil
    private var ud_pass:String? = nil
    private var ud_bbuserid:String? = nil
    private var ud_bbusername:String? = nil
    private var ud_bbpassword:String? = nil
    private var ud_jurl:String? = nil
    
   // var userNameObserver: NSKeyValueObservation?
   // var userPassObserver: NSKeyValueObservation?

    private func ud_init() -> (Bool) {
        
        ud_userName = UserDefaults.standard.string(forKey: Keys.userName)
       
        ud_pass = UserDefaults.standard.string(forKey: Keys.userPass)
        ud_bbuserid = UserDefaults.standard.string(forKey: Keys.bbuserid)
        ud_bbpassword = UserDefaults.standard.string(forKey: Keys.bbuserpassword)
        ud_bbusername = UserDefaults.standard.string(forKey: Keys.bbusername)
        ud_jurl = UserDefaults.standard.string(forKey: Keys.jurl)
        
        if ud_bbpassword != nil {return true}
            else
            {return false}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        // с использованием Observer
//        userPassObserver = UserDefaults.standard.observe(\.userPass,options: [.initial,.new], changeHandler: {
//            [weak self] (defaults, change) in
//            self?.ud_userName = change.newValue
//
//        })
        
        // читаем данные пользователя из UserDefaults в любом случае
        if ud_init() == true {
            if changeUserFlag == true {
                //вставляем данные пользователя в UI и не переходим на следующий экран
                LoginField.text = ud_userName!
                PassField.text = ud_pass!
                
                userName = ud_userName!
                pass = ud_pass!
                
                
            } else {
                
                // инициализация из userDefaults
                if ud_init() == true {
                    //print("пользак уже есть")
                    
                  
                    if let userDefaults = UserDefaults(suiteName: "group.liruios") {
                        let input =  userDefaults.string(forKey: "incomingURL")
                        print("input:\(input)")
                        if input != "" {
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "postvc") as! PostViewController
                            nextViewController.modalPresentationStyle = .fullScreen
                            
                            nextViewController.bbusername = ud_bbusername!
                            nextViewController.jurl = ud_jurl!
                            nextViewController.bbuserid = ud_bbuserid!
                            nextViewController.bbpassword = ud_bbpassword!
                            nextViewController.sharedText = input ?? ""
                          //  userDefaults.set("" as String, forKey: "incomingURL")
                          //  userDefaults.synchronize()
                            self.present(nextViewController, animated:true, completion:nil)
                           
                        }
                    }
                    
                   
//                    do {
//                    let input  = UserDefaults.standard.object(forKey: "incomingURL") as! Data
//                    decodedInput = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(input) as! String
//                    } catch {
//                        print("fail to decode")
//                    }
                   
                   
                    
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
                    nextViewController.modalPresentationStyle = .fullScreen
                    
                    nextViewController.bbusername = ud_bbusername!
                    nextViewController.jurl = ud_jurl!
                    nextViewController.bbuserid = ud_bbuserid!
                    nextViewController.bbpassword = ud_bbpassword!
                    nextViewController.username = ud_userName!
                    
                    
                    self.present(nextViewController, animated:true, completion:nil)
                
            }
        }
        
   
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
        
    
    }
    
    @IBOutlet weak var LoginField: UITextField!
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
           // print(response.debugDescription)
         //   print(HTTPCookieStorage.shared.cookies!)
           
         
            if response.debugDescription.contains("https://www.liveinternet.ru/member.php?rndm=") {
                self?.PassField.text = ""
                let alert = self?.createAlert() ?? UIAlertController()
                self?.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "spvc") as! SendPostViewController
                nextViewController.modalPresentationStyle = .fullScreen
                
                UserDefaults.standard.set(self?.userName,forKey: Keys.userName)
                UserDefaults.standard.set(self?.pass,forKey: Keys.userPass)
                nextViewController.username = self?.userName ?? "unnamed"
                
                
                
                
                
                for cookie in HTTPCookieStorage.shared.cookies! {
                   // print(cookie.name)
                    //print(cookie.value)
                    
                    if cookie.name == "bbusername" {
                        nextViewController.bbusername = cookie.value
                        UserDefaults.standard.set(cookie.value,forKey: Keys.bbusername)
                        
                    }
                    if cookie.name == "bbuserid" {
                        nextViewController.bbuserid = cookie.value
                        UserDefaults.standard.set(cookie.value,forKey: Keys.bbuserid)
                        
                    }
                    if cookie.name == "jurl" {
                        nextViewController.jurl = cookie.value
                        UserDefaults.standard.set(cookie.value,forKey: Keys.jurl)
                        
                    }
                    if cookie.name == "bbpassword" {
                        nextViewController.bbpassword = cookie.value
                        UserDefaults.standard.set(cookie.value,forKey: Keys.bbuserpassword)
                        
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
               
                
                //print(HTTPCookieStorage.shared.cookies!)
                if (!response.debugDescription.contains("error_register")) {
                    UserDefaults.standard.set(self.userName,forKey: Keys.userName)
                    UserDefaults.standard.set(self.pass,forKey: Keys.userPass)
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
                    nextViewController.username = self.userName
                    
                    for cookie in HTTPCookieStorage.shared.cookies! {
                       // print(cookie.name)
                        //print(cookie.value)
                        
                        if cookie.name == "bbusername" {
                            nextViewController.bbusername = cookie.value
                            UserDefaults.standard.set(cookie.value,forKey: Keys.bbusername)
                        }
                        if cookie.name == "bbuserid" {
                            nextViewController.bbuserid = cookie.value
                            UserDefaults.standard.set(cookie.value,forKey: Keys.bbuserid)
                        }
                        if cookie.name == "jurl" {
                            nextViewController.jurl = cookie.value
                            UserDefaults.standard.set(cookie.value,forKey: Keys.jurl)
                            
                        }
                        if cookie.name == "bbpassword" {
                            nextViewController.bbpassword = cookie.value
                            UserDefaults.standard.set(cookie.value,forKey: Keys.bbuserpassword)
                        }
                    }
               
                    self.present(nextViewController, animated:true, completion:nil)}
                else{
                    // показать алерт
                    let alert = self.createAlert()
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

extension UserDefaults {
    @objc dynamic var userName: String {
        return string(forKey: Keys.userName) ?? ""
    }
    @objc dynamic var userPass: String {
        return string(forKey: Keys.userPass) ?? ""
    }
}

