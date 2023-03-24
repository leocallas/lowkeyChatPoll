//
//  Message.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

enum MessageType {
    case text
    case poll
}

protocol MessageContent {
    associatedtype T
    var type: MessageType { get }
    var author: User { get }
    var content: T { get }
}

struct Message<T>: MessageContent {
    let type: MessageType
    let author: User
    let content: T
}
