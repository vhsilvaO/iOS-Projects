//
//  UserCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 17/11/22.
//

import Foundation

struct UserCellViewModel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.userName
    }
    
    var fullname: String {
        return user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
}
