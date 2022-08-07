//
//  ShareViewController.swift
//  LiruShareExtension
//
//  Created by Артем Солохин on 15.06.2022.
//

import UIKit
import Social
import MobileCoreServices
//https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701


class ShareViewController: SLComposeServiceViewController {
    
    private var appURLString = "myapp://home?url=com.chizztectep.liruios"

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        print("in didSelectPost")
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                let type = itemProvider.registeredTypeIdentifiers
                           let uti = type.first!
                           if itemProvider.hasItemConformingToTypeIdentifier(uti) {
                               itemProvider.loadItem(forTypeIdentifier:uti as String, options: nil, completionHandler: { (item, error) -> Void in
                                   
                                   let shareText = item.debugDescription
                                   print(shareText) //<_NSItemProviderSandboxedResource: 0x2839aa9e0>
                                   if let userDefaults = UserDefaults(suiteName: "group.liruios") {
                                       userDefaults.set(shareText as String,forKey:"incomingURL")
                                       userDefaults.synchronize()
                                   }
                                
                                   
//                                   do {
//                                       let  encodedData = try NSKeyedArchiver.archivedData(withRootObject: item ?? nil, requiringSecureCoding: false)
//                                       UserDefaults().set(encodedData, forKey: "incomingURL")
//                                   }
//                                   catch {
//                                       print("fail")
//                                   }
                                  
                               })
                           }
                    }
        }
        
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: {_ in
            guard let url = URL(string: self.appURLString) else { return }
            _ = self.openURL(url)
            
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
           var responder: UIResponder? = self
           while responder != nil {
               if let application = responder as? UIApplication {
                   return application.perform(#selector(openURL(_:)), with: url) != nil
               }
               responder = responder?.next
           }
           return false
       }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
