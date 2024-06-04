//
//  DatabaseManager.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 25/05/23.
//

import Foundation
import UIKit
import FirebaseDatabase
import MessageKit

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}

//MARK: - Login and Signup storage

extension DatabaseManager {
    
    
    /*
     Database Schema:
     
     OasisUsers => [
            userId =>
     
           [
                   "Email": String,
                   "Full name": String?,
                   "username": String?,
                   "isEmailVerified": true/false
     
            ],
            userId =>
     
            [
                   "Email": String,
                   "Full name": String?,
                   "username": String?,
                   "isEmailVerified": true/false
       
            ],
            ...
     ]
     
     */
    
    
    /*
     users => [
            [
                 email: String,
                 fullName: String
            ]
        ]
     
     */
    
    
    ///Creates a new OasisUser in Realtime Database
    public func insertUser(user: OasisUser, completion: @escaping (_ error: Error?) -> Void) {
        print(#function, "is called.")
        //Dictionary of type  [String: Dictionary] or [String: [String: Any]]
        let basics: [String: Any] =
        [
            "Basics":
                [
                    "email": user.safeEmail,
                    "fullName": user.fullName ?? "",
                    "username": user.username ?? "",
                    "isEmailVerified": user.isEmailVerified,
                    "userId": user.userId
                ] as [String: Any]
        ]
        
        ///This will automatically create a 'basics' node for the user.
        database.child(user.userId).setValue(basics) { [weak self] error, _ in
            
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let strongSelf = self else {return}
            
            ///Insert the user email into a separate node to allow searching.
            strongSelf.database.child("users").observeSingleEvent(of: .value) { snapshot in
                
                ///Checks if the users node has any user collection object.
                if var userCollection = snapshot.value as? [[String: String]] {
                    //append to user dictionary
                    let newUser =
                    [
                        [
                            "email": user.email,
                            "fullName": user.fullName ?? "",
                            "userId": user.userId
                        ]
                    ]
                    userCollection.append(contentsOf: newUser)
                    
                    ///Updates the users node with the new user added to it.
                    strongSelf.database.child("users").setValue(userCollection) { error, _ in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        
                        completion(nil)
                    }
                    
                }
                
                ///The users node does not exist yet.
                else {
                    //create that array
                    let newCollection: [[String: String]] =
                    [
                        [
                            "email": user.email,
                            "fullName": user.fullName ?? "",
                            "userId": user.userId
                        ]
                    ]
                    
                    strongSelf.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(error)
                            return
                            
                        }
                    }
                    
                    completion(nil)
                }
            }
            
        }
        
    }
    
    
    public func fetchUsers(completion: @escaping  (_ error: Error?, _ result: [[String: String]]? ) -> Void) {
        
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [[String: String]] else {
                completion(DatabaseError.failedToFetch, nil)
                return
            }
            completion(nil, users)
        }
        
    }
    
    
    ///Updates the OasisUser
    public func updateUser(userId: String, key: String, value: Any) {
        database.child("\(userId)/Basics").updateChildValues([key: value])
    }
    
    
    ///Download OasisUser from Realtime Database for Searching
    public func downloadOasisUser(userId: String, completion: @escaping (_ oasisUser: OasisUser?) -> Void) {
        
        database.child("\(userId)/Basics").observeSingleEvent(of: .value) { snapshot in
            
            let value = snapshot.value as? NSDictionary
            
            let oasisUser = OasisUser(
                userId: userId,
                fullName: value?["fullName"] as? String,
                email: value?["email"] as! String,
                username: value?["userName"] as? String,
                isEmailVerified: value?["isEmailVerified"] as! Bool
            )

            completion(oasisUser)
        }
        
    }
    
}



//MARK: - Fetch Conversations and Chats
extension DatabaseManager {
    
    
    /*
     Conversation Database Schema
     
     ConversationNode in the database with a value of [[String: Any]]:
     
     "Conversation_of_\(uid)_with_\(otherUserEmail)" =>
     
     Messages:
        [
          "message": Message
        
        
        
        ],
        
        [
        
        
        
        
        ]
         ...
     
     
     */
    
    
    
    ///When you use database.child("\(uid)/conversations").setValue(conversationsNode) function, the conversations array is automatically created
    ///at the specified location if even if doesn't exist. The conversationNode will contain all the values to add to the conversations.
    ///So, first you'll have to observe the value of the conversations if it exists and append the new item to the data and then set value.
    
    public func createNewConversation(uid: String, recipientEmail: String, recipientId: String, message: OasisMessage, completion: @escaping (Error?) -> Void) {
        
        print(#function, "is called.")
        ///Checks if the user node exists for the current user.
        database.child(uid).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
            guard let _ = snapshot.value as? [String: Any] else {
                print("The user doesn't exist.")
                return
            }
            
            guard let strongSelf = self else {return}
            
            let safeRecipientEmail = recipientEmail.replacingOccurrences(of: ".", with: "_")
            let messageDate = message.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            let conversationId: String = "Conversation_of_\(uid)_with_\(safeRecipientEmail)"
            print(conversationId)
            
            
            var newMessage = ""
            
            switch message.kind {
                
            case .text(let messageText):
                newMessage = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            
            //Dictionary
            
            let newConversation: [[String: Any]] =
            
            [
                [
                    "conversationId": conversationId,
                    "kind": message.kind.kindString,
                    "date": dateString,
                    "content": newMessage,
                    "is_read": false,
                    "recipientUid": recipientId,
                    "recipientEmail": safeRecipientEmail,
                    "sender": uid
                ]
            ]
            
            ///Checks if the conversations node exists for the current user.
            strongSelf.database.child("\(uid)/conversations").observeSingleEvent(of: .value) { snapshot, _  in
                
                ///The conversations node exists in the uid node.
                if var conversationsNode = snapshot.value as? [[String: Any]] {
                    
                    conversationsNode.append(contentsOf: newConversation)
                    
                    strongSelf.database.child("\(uid)/conversations").setValue(conversationsNode) { error, _ in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        
                        print("Saved to the conversations node successfully.")
                    }
                    
                    self?.updateConversationMessages(message: message, newMessage: newMessage, uid: uid, dateString: dateString, conversationId: conversationId, completion: { error in
                        completion(error)
                    })
                    
                }
                
                
                ///The conversations node does not exist in the uid node.
                else {
                    
                    strongSelf.database.child("\(uid)/conversations").setValue(newConversation) { error, _ in
                        
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        
                        
                        print("Created a conversations node and added to it successfully.")
                        
                    }
                    
                    self?.updateConversationMessages(message: message, newMessage: newMessage, uid: uid, dateString: dateString, conversationId: conversationId, completion: { error in
                        completion(error)
                    })
                    
                }
                
                //For the recipient user
                
                if uid != recipientId {
                    
                    ///Checks if the conversations node exists for the current user.
                    strongSelf.database.child("\(recipientId)/conversations").observeSingleEvent(of: .value) { snapshot, _  in
                        
                        ///The conversations node exists in the uid node.
                        if var conversationsNode = snapshot.value as? [[String: Any]] {
                            
                            conversationsNode.append(contentsOf: newConversation)
                            
                            strongSelf.database.child("\(recipientId)/conversations").setValue(conversationsNode) { error, _ in
                                guard error == nil else {
                                    completion(error)
                                    return
                                }
                                
                                print("Saved to the conversations node successfully.")
                            }
                            
                            self?.updateConversationMessages(message: message, newMessage: newMessage, uid: uid, dateString: dateString, conversationId: conversationId, completion: { error in
                                completion(error)
                            })
                            
                        }
                        
                        
                        ///The conversations node does not exist in the uid node.
                        else {
                            
                            strongSelf.database.child("\(recipientId)/conversations").setValue(newConversation) { error, _ in
                                
                                guard error == nil else {
                                    completion(error)
                                    return
                                }
                                
                                print("Created a conversations node and added to it successfully.")
                            }
                            
                            self?.updateConversationMessages(message: message, newMessage: newMessage, uid: uid, dateString: dateString, conversationId: conversationId, completion: { error in
                                completion(error)
                            })
                            
                        }
                        
                    }
                    
                }
            }
            
            //if the conversations node doesn't exist for the current user, create it and then add to it
        }
    }
    
    private func updateConversationMessages(message: OasisMessage, newMessage: String, uid: String, dateString: String, conversationId: String, completion: @escaping (Error?) -> Void) {
        
        let conversation: [String: Any] = [
        
            "id": message.messageId,
            "content": newMessage,
            "kind": message.kind.kindString,
            "is_read": false,
            "date": dateString,
            "sender_uid": uid
            
        ]
        
        let value: [String: Any] = [
        
            "messages": [
            conversation
            ]
        
        ]
        
        database.child("\(conversationId)").setValue(value) { error, _ in
            
            guard error == nil else {
                completion(error)
                return
            }
        }
    }
    
    
    
    
    ///The conversations node will store all the conversations only with the last message to show the conversations view controller.
    ///This will be present in the 'uid' node below the 'Basics' node.
    ///
    ///The 'Conversation_of_\(uid)_with_\(otherUserEmail)' node will contains all the messsages of the user with a single user. This will be a separate node.
    
    public func getAllConversations(userId: String, completion: @escaping (_ conversations: [[String: Any]]?, _ error: String?) -> Void) {
        
        database.child("\(userId)/conversations").observe(.value) { snapshot in
            print(snapshot)
             
            guard let conversations = snapshot.value as? [[String: Any]] else {
                completion(nil, "snapshot doesn't exist as [[String: Any]] or it's empty.")
                return
            }
            
            completion(conversations, nil)
        }
    }
    
    public func getAllMessagesForConversation(with conversationId: String, completion: @escaping (_ messages: [[String: Any]]?, _ error: String?) -> Void) {
        
        database.child("\(conversationId)/messages").observe(.value) { snapshot in
            print(snapshot.value)
            guard let messages = snapshot.value as? [[String: Any]] else {
                completion(nil, "no messages")
                return
            }
            
            completion(messages, nil)
        }
        
    }
    
    public func sendMessages(to conversation: String, uid: String, message: OasisMessage, completion: @escaping (Bool) -> Void) {
        print(#function)
        database.child("\(conversation)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else {return}
            guard var messages = snapshot.value as? [[String: Any]] else {return}
            
            var messageString = ""
            
            switch message.kind {
                
            case .text(let messageText):
                messageString = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let messageDate = message.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            let newMessage: [String: Any] = [
            
                "id": message.messageId,
                "content": messageString,
                "kind": message.kind.kindString,
                "is_read": false,
                "date": dateString,
                "sender_uid": uid
                
            ]
            
            messages.append(newMessage)
            strongSelf.database.child("\(conversation)/messages").setValue(messages)
            completion(true)
        }
    }
    
     
}

