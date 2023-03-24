//
//  User.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

struct User {
    let fullName: String
    let avatar: UIImage?
    
    static let current = User(fullName: "Levan Koberidze", avatar: .init(named: "currentUserImage"))
}
