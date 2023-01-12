//
//  AuthenticationViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 17/10/22.
//

import Foundation
import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formatIsValid: Bool { get }
    var backgroundColorButton: UIColor { get }
    var titleColorButton: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formatIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && email?.isValidEmail == true
    }
    
    var backgroundColorButton: UIColor {
        return formatIsValid ? UIColor(red: 0.292, green: 0.081, blue: 0.6, alpha: 255) : UIColor.systemPurple.withAlphaComponent(0.5)
    }
    
    var titleColorButton: UIColor {
        return formatIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegisterViewModel: AuthenticationViewModel {
    var fullName: String?
    var userName: String?
    var email: String?
    var password: String?
    
    var formatIsValid: Bool {
        return fullName?.isEmpty == false && userName?.isEmpty == false
        && email?.isEmpty == false && password?.isEmpty == false
        && email?.isValidEmail == true
    }
    
    var backgroundColorButton: UIColor {
        return formatIsValid ? UIColor(red: 0.292, green: 0.081, blue: 0.6, alpha: 255) : UIColor.systemPurple.withAlphaComponent(0.5)
    }
    
    var titleColorButton: UIColor {
        return formatIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?
    
    var formatIsValid: Bool {
        return email?.isEmpty == false
        && email?.isValidEmail == true
    }
    
    var backgroundColorButton: UIColor {
        return formatIsValid ? UIColor(red: 0.292, green: 0.081, blue: 0.6, alpha: 255) : UIColor.systemPurple.withAlphaComponent(0.5)
    }
    
    var titleColorButton: UIColor { return formatIsValid ? .white : UIColor(white: 1, alpha: 0.67) }
}
