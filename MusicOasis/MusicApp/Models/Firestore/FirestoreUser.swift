//
//  FirestoreUser.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 21/05/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class FirestoreUser {
    
    //define user properties
    
    let userId: String
    var fullName: String?
    var email: String
    var username: String?
    var isEmailVerified: Bool
    
    //initialiser for new user
    
    init(userId: String, fullName: String? = nil, email: String, username: String? = nil, isEmailVerified: Bool = false) {
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.username = username
        self.isEmailVerified = isEmailVerified
    }
    
    //initialiser for firestore user
    
    init(userDictionary: NSDictionary) {
        
        self.userId = userDictionary[kUserId] as! String
        self.fullName = userDictionary[kFullName] as? String
        self.email = userDictionary[kEmail] as! String
        self.username = userDictionary[kUsername] as? String
        self.isEmailVerified = userDictionary[kEmailVerified] as! Bool
    }
    
    
    //login FirestoreUser
    
    class func login(email: String, password: String, completion: @escaping (_ error: Error?, _ emailVerified: Bool) -> Void) {
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                completion(error, false)
                return
            }
            
            if authResult!.user.isEmailVerified {
                downloadUserFromFirestore(userId: authResult!.user.uid, email: email)
                completion(error, true)
            } else {
                completion(error, false)
            }
        }
        
    }
    
    
    
    //SignUp FirestoreUser
    
    class func signUp(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            completion(error)
            
            if error == nil {
                
                authResult!.user.sendEmailVerification { error in
                    print("Email verification error: ", error?.localizedDescription as Any)
                }
                print(#function, "Please check your email for the verification mail!")
                
                let oasisUser = OasisUser(userId: authResult!.user.uid, fullName: "", email: email, username: "", isEmailVerified: false)
                
                DatabaseManager.shared.insertUser(user: oasisUser) { error in
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    //Send password reset code to FirestoreUser
    
    class func forgotPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
            
        }
    }
    
    //verify password reset code for FirestoreUser
    
    class func verifyPasswordReset(resetCode: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FirebaseAuth.Auth.auth().verifyPasswordResetCode(resetCode) { stringValue, error in
            
            completion(error)
            print(error?.localizedDescription as Any)

            if error == nil {
                print(stringValue!)
            }
        }
    }
    
    
    //Confirm password reset for FirestoreUser
    
    class func confirmPasswordReset(resetCode: String, newPassword: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FirebaseAuth.Auth.auth().confirmPasswordReset(withCode: resetCode, newPassword: newPassword) { error in
            
            completion(error)
            print(error?.localizedDescription as Any)
        }
    }
}


//download user from firestore function

func downloadUserFromFirestore(userId: String, email: String) {
    
    Firestore.firestore().collection("User").document(userId).getDocument { snapshot, error in
        
        
        guard error == nil else {return}
        
        guard let snapshot = snapshot else {return}
        
        if snapshot.exists {
            //download user from firestore
            saveUserLocally(user: snapshot.data()! as NSDictionary)
        }
        else {
            //create new user in Firestore
            let user = FirestoreUser(userId: userId, email: email)
            saveUserToFirestore(user: user) { error in
                print(#function, "Error while saving user to Firestore: ",error?.localizedDescription as Any)
            }
            
        }
        
        print("User snapshot: ",snapshot)
        
    }
}

//save user to firestore function

func saveUserToFirestore(user: FirestoreUser, completion: @escaping (_ error: Error?) -> Void) {
    
    Firestore.firestore().collection("User").document(user.userId).setData(firestoreDictionaryWith(user: user) as! [String:  Any]) { error in
        completion(error)
        print(#function, "Error while saving user to Firestore: ", error?.localizedDescription as Any)
        
    }
    
}

//save user locally

func saveUserLocally(user: NSDictionary) {
    
    UserDefaults.standard.set(user, forKey: kCurrentUser)
    UserDefaults.standard.synchronize()
}

//convert new FirestoreUser NSDictionary function

func firestoreDictionaryWith(user: FirestoreUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.userId, user.email, user.fullName ?? "", user.username ?? user.email], forKeys: [kUserId as NSCopying, kEmail as NSCopying, kFullName as NSCopying, kUsername as NSCopying])
}

