//
//  FavoritesListController.swift
//  LiruIos
//
//  Created by Артем Солохин on 28.02.2022.
//

import Foundation
import UIKit
import CoreData
import SnapKit

class FavoritesListController: UIViewController {
    var bbuserid=""
    var bbusername=""
    var bbpassword = ""
    var jurl = ""
    
    var selectedFriend:FavoritesModel?
    
  
    
    private let persistContainer = NSPersistentContainer(name:"Model")
    
    private lazy var FavoritesResultsController:NSFetchedResultsController<FavoritesModel> = {
        let fetchRequest = FavoritesModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key:"nick", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "bbuserid == %@", bbuserid)
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext: self.persistContainer.viewContext,sectionNameKeyPath:nil,cacheName:nil)
       // fetchedResultController.delegate = self
        return fetchedResultController
        
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        SearchBar.delegate = self
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
          //  make.centerY.equalTo(view.snp.centerY)
          //  make.centerX.equalTo(view.snp.centerY)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.bottom).inset(60)
        }
        
        
        persistContainer.loadPersistentStores(completionHandler: {
            (persistentStoreDescription,error) in
            if let error = error {
                print("unable to load Persistent Store \(error.localizedDescription)")
            } else
            {
                do {
                    try self.FavoritesResultsController.performFetch()
                } catch  {
                    print(error)
                }            }
        })
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    private func GetRssWithCompletion(url:URL,completion: @escaping(_ rssString:String) -> ()) {
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded;charset=win-1251", forHTTPHeaderField: "Content-Type")
        // Form URL-Encoded Body
        let cookieString = "chbx=guest; jurl=\(jurl);ucss=normal; bbuserid=\(bbuserid); bbpassword=\(bbpassword); bbusername=\(bbusername)"
        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {

            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
               // print("URL Session Task Succeeded: HTTP \(statusCode)")
                if statusCode == 200 {
                    let responseString = NSString(data: data!, encoding: String.Encoding.win1251.rawValue)
                   
                    completion(responseString as! String)
                }
               
              
            
              }
              else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
              }}
            })
        task.resume()
        
        
        
    }
    
    @IBAction func getPostsButton(_ sender: UIButton) {
        guard let selectedFriend = selectedFriend else {return}
        
        let rssUlr = "\(selectedFriend.url!)/rss"
    
        activityIndicator.startAnimating()
        GetRssWithCompletion(url: URL(string: rssUlr)!) { rssString in
            print(rssString)
            self.activityIndicator.stopAnimating()
        }
        
        
    }
    
 
    
    
    
}

extension FavoritesListController:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    func tableView(_ tableView:UITableView, canEditRowAt indexPath:  IndexPath) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar,
                            textDidChange searchText: String) {
        
      
        // сфетчить данные по имени
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoritesModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nick CONTAINS[c] %@", searchText)
        
        FavoritesResultsController.fetchRequest.predicate = fetchRequest.predicate
        try? FavoritesResultsController.performFetch()
        tableView.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.FavoritesResultsController.sections else {
               fatalError("No sections in FavoritesResultsController")
           }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
 
    }
    
    func numberOfSections(in tableView:UITableView) -> Int {
    
       return FavoritesResultsController.sections?.count ?? 0

    }
    
    // метод обрабатывающий нажатие на ячейку
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath) {
        selectedFriend = FavoritesResultsController.object(at: indexPath)
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = FavoritesResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = friend.nick
        return cell
    }
    
    
}
