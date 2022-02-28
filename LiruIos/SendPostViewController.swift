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
