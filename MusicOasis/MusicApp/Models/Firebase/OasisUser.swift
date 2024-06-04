//
//  OasisUser.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 28/05/23.
//

import Foundation

public struct OasisUser {
     
    //define user properties
    
    public let userId: String
    public var fullName: String?
    public var email: String
    public var username: String?
    public var isEmailVerified: Bool
     
    public var safeEmail: String {
        
        let safeEmail = email.replacingOccurrences(of: ".", with: "_")
        print("SAFE EMAIL\n", safeEmail)
        return safeEmail
    }
}
