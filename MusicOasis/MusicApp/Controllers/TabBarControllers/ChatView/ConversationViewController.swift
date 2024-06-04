//
//  ConversationViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 11/05/23.
//

import Foundation
import UIKit
import FirebaseAuth

struct Conversation {
    let recipientUid: String
    let recipientEmail: String
    let lastestMessage: OasisMessage
    
}


class ConversationViewController: UITableViewController  {
   
    private var conversations: [[String: Any]]?
    private var uid: String = FirebaseAuth.Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Music Oasis"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        tableView.rowHeight = 62
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DatabaseManager.shared.getAllConversations(userId: uid) { [weak self] conversations, error in
            print(#function, "is called in ConversationViewController.")
            guard error == nil else {
                print(error)
                return
            }
            print(conversations)
            self?.conversations = conversations
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func newConversationPressed(_ sender: UIBarButtonItem) {
        
        /*
         
         Allow the user to search the username of the recipient.
         If the user selects the username, show the ChatViewController.
         */
        
        
        ///Modal view controllers are not part of the navigation controller stack. If a view controller is pushed, then it's part of the navigation controller stack.
        let userSearchController = UserSearchController()
        userSearchController.completion = { [weak self] result in

            guard let strongSelf = self else {return}
            let safeEmail = result["email"]?.replacingOccurrences(of: ".", with: "_")
            if strongSelf.conversations != nil {
                var isNew = true
                
                for conversation in strongSelf.conversations! {
                    
                    if conversation["conversationId"] as! String == "Conversation_of_\(strongSelf.uid)_with_\(safeEmail!)" {
                        isNew = false
                        return
                    }
                    
                }
                
                strongSelf.chatWith(result: result, isNew: isNew)
                
            } else {
                strongSelf.chatWith(result: result, isNew: true)
            }
        }
        
        let navigationController = UINavigationController(rootViewController: userSearchController)
        present(navigationController, animated: true)
       
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        AuthenticationManager.shared.signOut { error in
            print(error?.localizedDescription as Any)
            UserDefaults.standard.removeObject(forKey: "OasisUser")
        }
    }
    
    private func chatWith(result: [String: String], isNew: Bool) {
        
        let chatViewController = ChatViewController()
        chatViewController.isNewConversation = isNew
        chatViewController.title = result["email"]
        chatViewController.recipientEmail = result["email"]
        chatViewController.recipientUid = result["userId"]
        chatViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
    //TODO: -
    
    //1. UI for the chat controller.
    //2. Firebase for the chat function.
    //3. List all the functions; example - sheet.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationCell
        cell.emailLabel.text = conversations?[indexPath.row]["recipientEmail"] as? String
        cell.lastestMessageLabel.text = conversations?[indexPath.row]["content"] as? String
        cell.userImageView.image = UIImage(systemName: "person.circle")?.withTintColor(#colorLiteral(red: 0.4962328076, green: 0.5062246323, blue: 0.9835080504, alpha: 1), renderingMode: .alwaysOriginal)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.hidesBottomBarWhenPushed = true
        chatViewController.recipientEmail = conversations?[indexPath.row]["recipientEmail"] as? String
        chatViewController.isNewConversation = false
        chatViewController.conversationId = conversations?[indexPath.row]["conversationId"] as? String
        navigationController?.pushViewController(chatViewController, animated: true)
        
    }

}

