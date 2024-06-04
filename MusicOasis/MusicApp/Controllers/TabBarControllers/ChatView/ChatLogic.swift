//
//  ChatLogic.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 07/06/23.
//

/*
 
 ConversationViewController:
 
 In viewDidLoad(), load the tableView with the Conversation data.
 Conversation data will be an array of Conversation -> var conversations: [Conversation]
 
 They will be saved to Real-time database.
 
 struct Conversation {
    profileUrl (of the sender)
    sender
    senderEmail
    lastMessage
    isRead
 }
 
The lastMessage can be from the user or from the sender. It will be the last message in the conversation.
 
 Add an observer to the Conversation data so that when ConversationViewController is the current view controller, the tableView will be updated automatically.
 
 
 In didSelectRowAt:
 
 Go to ChatViewController.
 
 
 ChatViewController:
 
 In the viewDidLoad() of the ChatViewController, reload the collectionView from MessageKit which displays messages.
 
 The collectionView will have the functions required by the MessageKit library.
 It will have InputBarView for typing messages and sending them.
 
 The messages will be an array of Message model.
 
 They will be saved to Real-time database.
 
 struct Message {
 
 message
 sender
 recipient
 date(time)
 
 }
 
 
 When the send button is pressed and the text is not empty:
 
 Save the message to real-time database.
 Refresh the collectionView.
 
 
 
 In DatabaseManager:
 
 
 The database schema:
 
 /*
  Database Schema:
  
  OasisUsers => [
  
         userId(uid) =>
    [ "Basics":
        [
                "Email": String,
                "Full name": String?,
                "username": String?,
                "isEmailVerified": true/false
  
         ],
  
      "Conversations":
  
  //Array of dictionaries -> [[String: Any?]]
  // [Conversation struct]
        [
                [
                  "profileUrl": "url",
                  "sender": String,
                  "senderEmail": String,
                  "lastMessage": String,
                  "isRead": Bool
  
                ],
                [
                  "profileUrl": "url",
                  "sender": String,
                  "senderEmail": String,
                  "lastMessage": String,
                  "isRead": Bool
  
                ],
                ...
      
  
        ],
  
    ],
  
         userId(uid) =>
    [ "Basics":
         [
                "Email": String,
                "Full name": String?,
                "username": String?,
                "isEmailVerified": true/false
    
         ],
  
       "Conversations":
     
     //Array of dictionaries -> [[String: Any?]]
     // [Conversation struct]
        [
            [
                   "profileUrl": "url",
                   "sender": String,
                   "senderEmail": String,
                   "lastMessage": String,
                   "isRead": Bool
     
            ],
            [
                   "profileUrl": "url",
                   "sender": String,
                   "senderEmail": String,
                   "lastMessage": String,
                   "isRead": Bool
     
            ],
                 ...
     
     
        ],
  
     ],
         ...
  ]
  
  */
 
 */
