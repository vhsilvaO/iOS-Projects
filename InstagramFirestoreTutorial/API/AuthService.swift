//
//  AuthService.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 18/10/22.
//

import UIKit
import Firebase

struct AuthCredentials {
    let profileImage: UIImage
    let fullName: String
    let userName: String
    let email: String
    let password: String
}

struct AuthService {
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = [ "fullName": credentials.fullName,
                                          "userName": credentials.userName,
                                          "email": credentials.email,
                                          "profileImageUrl": imageUrl,
                                          "uid": uid]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func resetPassword(withEmail email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
