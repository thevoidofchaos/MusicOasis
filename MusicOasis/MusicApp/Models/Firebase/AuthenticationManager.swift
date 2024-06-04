//
//  AuthenticationManager.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 25/05/23.
//

import Foundation
import FirebaseAuth
import UIKit

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private let authentication = FirebaseAuth.Auth.auth()
    
    
    ///Sign up new OasisUser
    public func signUp(with email: String,
                password: String,
                completion: @escaping ((_ error: Error?) -> Void)) {
        
        authentication.createUser(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                completion(error)
                return
            }
            
            authResult?.user.sendEmailVerification { error in
                
                guard error == nil else {
                    completion(error)
                    return
                }
                
                let oasisUser = OasisUser(userId: (authResult?.user.uid)!, email: email, isEmailVerified: false)
                DatabaseManager.shared.insertUser(user: oasisUser) { error in 
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    
    ///Login OasisUser
    public func login(with email: String,
               password: String,
               completion: @escaping ((_ error: Error?, _ isEmailVerified: Bool,_ userId: String?) -> Void)) {
        
        
        authentication.signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                completion(error, false, nil)
                return
            }
            
            if authResult!.user.isEmailVerified {
                
                //Download the current user from Realtime Database
                //Save the current user locally
                completion(error, true, authResult!.user.uid)
            } else {
                completion(error, false, authResult!.user.uid)
            }
        }
    }
    
    ///SignOut OasisUser
    public func signOut(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try authentication.signOut()
        
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController("LoginViewController")
        }
        catch {
            completion(error)
        }
    }
}
