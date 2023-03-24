//
//  ChatPoll.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

struct ChatPoll {
    let question: String
    let options: [Option]
    let votes: Int = .zero
    let author: User?
}
