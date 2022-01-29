//
//  SendPostViewController.swift
//  LiruIos
//
//  Created by Артем Солохин on 27.01.2022.
//

import Foundation
import UIKit

class SendPostViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var backbutton = UIButton(type: .custom)
       
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    private func SetupViews() {
       // var backButton = UIBarButtonItem()
//        backButton.setTitle("Back", for: .normal)
//        backButton.setTitleColor(backButton.tintColor, for: .normal)
//        backButton.addTarget(self, action: "backAction", for: .touchUpInside)
      //  self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
//    self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
}
