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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("bbuserid:\(bbuserid)")
       
    }
    
    @IBAction func ChangeUserButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "lgvc") as! ViewController
        nextViewController.modalPresentationStyle = .fullScreen
       
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    private func SetupViews() {
     
        
    }
    
  
    
}
