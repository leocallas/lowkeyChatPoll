//
//  ChatViewModel.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import Foundation

protocol ChatViewModelProtocol {
    var messages: [Message] { get }
    func loadMessages()
    func sendMessage(_ message: String)
}

final class ChatViewModel: ChatViewModelProtocol {

    // MARK: - Public Properties

    private(set) var messages: [Message] = []

    // MARK: - Private Properties

    private let dummyData = DummyData()

    // MARK: - Methods

    func loadMessages() {
        messages = dummyData.messages
    }

    func sendMessage(_ message: String) {
        messages.append(.init(author: "Levan Koberidze", authorImage: .init(named: "currentUserImage"), message: message))
    }
}
