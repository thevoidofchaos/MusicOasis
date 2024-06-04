//
//  UserSearchController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 08/06/23.
//

import Foundation
import UIKit

class UserSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    public var completion: (([String:String]) -> Void)?
    
    let searchBar = UISearchBar()
    var hasFetched: Bool = false
    var userCollection: [[String: String]] = []
    var results: [[String: String]] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UsernameCell.self, forCellReuseIdentifier: "usernameCell")
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appBackgroundColor
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(dismissController))
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchBar.becomeFirstResponder()
        
    }
    
    @objc private func dismissController() {
        self.dismiss(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        
        /*
         get the text
         get all users from Firebase if hasFetched is false
         if all the users all already fetched, just filter
         
         (I don't know what would happen if we were to add a new user -> observeSingleEvent).
         I guess the userCollection will be fetched each time the user view controller is presented as new in memory.
         
         save the users locally
         filter the locally saved users for the fullName has prefix of the search term
         */
        
        results.removeAll()
        
        if hasFetched {
            //the user collection is already locally present.
            //call the filter function on user collection.
            filterUsers(term: text)
        } else {
            //create a new user collection and pass the search term for the filter function.
            fetchAllUsers(query: text)
        }
        
    }
    
    func fetchAllUsers(query: String) {
        
        DatabaseManager.shared.fetchUsers { [weak self] error, users in
            guard error == nil else {
                print(error as Any)
                return
            }
            
            guard let strongSelf = self else {return}
            strongSelf.userCollection = users!
            strongSelf.hasFetched = true
            strongSelf.filterUsers(term: query)
            
        }
    }
    
    func filterUsers(term: String) {
        
        guard hasFetched else {return}
        
        let results: [[String:String]] = userCollection.filter({
            guard let email = $0["email"]?.lowercased() as? String else {
                return false
            }
            
            return email.hasPrefix(term.lowercased())
        })
        
        self.results = results
        
        updateUserUI()
        
    }
    
    func updateUserUI() {
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usernameCell", for: indexPath) as! UsernameCell
        cell.usernameLabel.text = results[indexPath.row]["email"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     let targetUserData = results[indexPath.row]
        dismiss(animated: true) { [weak self] in
            print(targetUserData)
            self?.completion?(targetUserData)
        }
    }
    
}
