//
//  FriendsList.swift
//  LiruIos
//
//  Created by Артем Солохин on 14.02.2022.
//

import Foundation
import UIKit
import Alamofire
import XMLMapper
import CoreData

class FriendsListController: UIViewController {
    
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    
    private let persistContainer = NSPersistentContainer(name:"Model")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FriendModel> = {
        let fetchRequest = FriendModel.fetchRequest()
    
        let sortDescriptor = NSSortDescriptor(key:"nick", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "bbuserid == %@", bbuserid)


        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext: self.persistContainer.viewContext,sectionNameKeyPath:nil,cacheName:nil)
       // fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        persistContainer.loadPersistentStores(completionHandler: {
            (persistentStoreDescription,error) in
            if let error = error {
                print("unable to load Persistent Store \(error.localizedDescription)")
            } else
            {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch  {
                    print(error)
                }            }
        })
        
        
    }
    
    private func GetFriendsWithCompletion(url:URL,completion: @escaping(_ status:String) -> ()) {
       
      
        let task = URLSession.shared.dataTask(with:url)  {(data, response, error) in
            DispatchQueue.main.async {
            let responseString = NSString(data: data!, encoding: String.Encoding.win1251.rawValue)
            
          //  print(responseString)
               
        if  let friends = XMLMapper<Friend>().map(XMLString: responseString as! String) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FriendModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "bbuserid == %@", self.bbuserid)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
           
                // perform the delete
                do {
                try self.persistContainer.viewContext.execute(deleteRequest)
            } catch let error as NSError {
                               print(error)
            }
            
            
            for fr in friends.person!.knows! {
                let friend = FriendModel.init(entity: NSEntityDescription.entity(forEntityName: "FriendModel", in: (self.persistContainer.viewContext))!, insertInto: self.persistContainer.viewContext)
                
                friend.bbuserid = self.bbuserid
                if fr.foaf != nil {
                    friend.url = fr.foaf?.weblog?.resource
                    friend.nick = fr.foaf?.nick.win1251Encoded.removingPercentEncoding
                    if friend.nick == nil {
                        friend.nick = fr.foaf?.nick.win1251Encoded.replacingOccurrences(of: "%3F", with: "%98").removingPercentEncoding
                        //print(friend.nick)
                    }
                   
                    friend.name = fr.foaf?.name
                }
                if fr.Group != nil {
                    friend.url = fr.Group?.weblog?.resource
                    friend.nick = fr.Group?.nick.win1251Encoded.removingPercentEncoding
                    if friend.nick == nil {
                        friend.nick = fr.Group?.nick.win1251Encoded.replacingOccurrences(of: "%3F", with: "%98").removingPercentEncoding
                    }
                    
                  
                    friend.name = fr.Group?.name
                }
               
                try? friend.managedObjectContext?.save()
            }
            completion("OK")
        }
        }
    }
        task.resume()
    }
    
    @IBAction func onUpdateButtonClicked(_ sender: UIButton) {

        
        jurl = jurl.replacingOccurrences(of: "%3A", with: ":")
            .replacingOccurrences(of: "%2F", with: "/")
        if (jurl.contains("liveinternet.ru")) {
            jurl = jurl.replacingOccurrences(of: "http://", with: "https://")
        }
        
        let foafUrl = "\(jurl)foaf"
        
        GetFriendsWithCompletion(url: URL(string: foafUrl)!) { status in
            if status == "OK" {
                self.tableView.reloadData()
            }
        }
}
    
}

extension FriendsListController:UITableViewDataSource {
   
    func tableView(_ tableView:UITableView, canEditRowAt indexPath:  IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
               fatalError("No sections in fetchedResultsController")
           }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
 
    }
    
    func numberOfSections(in tableView:UITableView) -> Int {
    
       return fetchedResultsController.sections?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = friend.nick
       // print("\(indexPath) \(friend.nick)")
        return cell
    }
    
    
}


