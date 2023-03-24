//
//  ChatPoll.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

struct ChatPoll: Equatable {
    let question: String
    let options: [Option]
    let votes: Int = .zero
    let author: User?
    
    static func == (lhs: ChatPoll, rhs: ChatPoll) -> Bool {
        lhs.question == rhs.question
        && lhs.options == rhs.options
        && lhs.votes == rhs.votes
        && lhs.author == rhs.author
    }
}
