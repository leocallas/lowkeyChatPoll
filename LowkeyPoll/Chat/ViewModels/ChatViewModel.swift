//
//  ChatViewModel.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import Foundation

protocol ChatViewModelProtocol {
    var messages: [any MessageContent] { get }

    func loadMessages()
    func sendTextMessage(_ message: String)
    func sendPoll(_ poll: ChatPoll)
}

final class ChatViewModel: ChatViewModelProtocol {

    // MARK: - Public Properties

    private(set) var messages: [any MessageContent] = []

    // MARK: - Private Properties

    private let dummyData = DummyData()

    // MARK: - Methods

    func loadMessages() {
        messages = dummyData.messages
    }

    func sendTextMessage(_ message: String) {
        messages.append(Message(type: .text, author: .current, content: message))
    }

    func sendPoll(_ poll: ChatPoll) {
        messages.append(Message(type: .poll, author: .current, content: poll))
    }
}
