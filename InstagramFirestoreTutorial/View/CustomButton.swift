//
//  CustomButton.swift
//  InstagramFirestoreTutorial
//
//  Created by vicoliveira on 17/10/22.
//

import UIKit

class CustomButton: UIButton {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        setTitle(placeholder, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.systemPurple.withAlphaComponent(0.5)
        layer.cornerRadius = 5
        setHeight(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
