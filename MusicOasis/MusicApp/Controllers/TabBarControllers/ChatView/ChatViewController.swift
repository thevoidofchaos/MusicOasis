//
//  ChatViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 26/05/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth

class ChatViewController: MessagesViewController {
    
    let date = Date()
    var recipientEmail: String?
    var isNewConversation: Bool?
    var uid: String?
    var recipientUid: String?
    var conversationId: String?
    private var messages = [OasisMessage]()
    private var selfSender: Sender?
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(conversationId)
        DatabaseManager.shared.getAllMessagesForConversation(with: conversationId!) { [weak self] messages, error in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let strongSelf = self else {return}
            
            for message in messages! {
                if let senderId = message["sender_uid"] as? String, senderId == strongSelf.recipientUid  {
                    let sender = Sender(senderId: senderId, displayName: "")
                    let date = ChatViewController.dateFormatter.date(from: message["date"] as! String)
                    let oasisMessage = OasisMessage(sender: sender, messageId: message["id"] as! String, sentDate: date!, kind: .text(message["content"] as! String))
                    strongSelf.messages.append(oasisMessage)
                } else {
                    let sender = Sender(senderId: message["sender_uid"] as! String, displayName: "")
                    let date = ChatViewController.dateFormatter.date(from: message["date"] as! String)
                    let oasisMessage = OasisMessage(sender: sender, messageId: message["id"] as! String, sentDate: date!, kind: .text(message["content"] as! String))
                    strongSelf.messages.append(oasisMessage)
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.messagesCollectionView.reloadData()
            }
            
            print("------------------\n******************")
            print(strongSelf.messages)
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        messageInputBar.inputTextView.becomeFirstResponder() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = FirebaseAuth.Auth.auth().currentUser?.uid
        selfSender = Sender(senderId: uid!, displayName: "Kushagra Shukla")
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
    
    
    //TODO: -
    
    //1. UI for the chat controller.
    //2. Firebase for the chat function.
    //3. List all the functions; example - sheet.
    
    
}


extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate  {
    
    var currentSender: SenderType {
        return selfSender!
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        print(messages[indexPath.section])
        return messages[indexPath.section] 
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print(#function)
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let messageId = getMessageId(),
        let sender = selfSender
               
        else {
            print("Something is nil here!")
            return
            
        }
        
        //Send the message to Real-time Database
        //Reload the CollectionView with the messages data.
        print("here")
        print("is new conversation is", isNewConversation)
        if isNewConversation != nil {
            print("Is new conversation is not nil")
            if isNewConversation! {
                print("Add new conversation? - ", isNewConversation!)
                
                guard uid != nil, recipientEmail != nil, recipientUid != nil else {
                    print(uid, recipientEmail, recipientUid, "are the values in ChatViewController.")
                    return
                }
            
                let message = OasisMessage(sender: sender, messageId: messageId, sentDate: Date(), kind: .text(text))
                
                DatabaseManager.shared.createNewConversation(uid: uid!, recipientEmail: recipientEmail!, recipientId: recipientUid!, message: message) { error in
                    print("Database Error: ", error  as Any)
                }
                isNewConversation = false
            } else {
                //send messaage
                print("Send Message")
                let safeRecipientEmail = recipientEmail!.replacingOccurrences(of: ".", with: "_")
                let message = OasisMessage(sender: sender, messageId: messageId, sentDate: Date(), kind: .text(text))
                let conversationId = "Conversation_of_\(uid!)_with_\(safeRecipientEmail)"
                DatabaseManager.shared.sendMessages(to: conversationId, uid: uid!, message: message) { _ in
                    print("Message sent.")
                    
                }
                
            }
        }
        
    }
    
    func getMessageId() -> String? {
        
        guard uid != nil, recipientEmail != nil else {
            return nil
        }
        
        let dateString = Self.dateFormatter.string(from: Date())
        return "\(uid!)_\(recipientEmail!)_\(dateString)"
    }
}

