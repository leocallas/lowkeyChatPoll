//
//  LowkeyPollTests.swift
//  LowkeyPollTests
//
//  Created by Lkoberidze on 22.03.23.
//

import XCTest
@testable import LowkeyPoll

final class ChatViewModelTests: XCTestCase {

    var sut: ChatViewModelProtocol!

    override func setUpWithError() throws {
        sut = MockChatViewModel()
        sut.loadMessages()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testLoadMessages() throws {
        XCTAssertEqual(sut.messages.count, LowkeyPoll.DummyData().messages.count)
    }
    
    func testSendTextMessage() throws {
        let message = "Test Message"
        sut.sendTextMessage(message)
        XCTAssertTrue(sut.messages.contains(where: { ($0.content as? String) == message }))
    }
    
    func testSendPollMessage() throws {
        let poll = ChatPoll(question: "Test Question", options: [.init(index: .zero, text: "Option 1"), .init(index: 1, text: "Option 2")], author: .current)
        sut.sendPoll(poll)
        XCTAssertTrue(sut.messages.contains(where: { ($0.content as? ChatPoll) == poll }))
    }
    
}

final class MockChatViewModel: ChatViewModelProtocol {
    var messages: [any LowkeyPoll.MessageContent] = []
    
    func loadMessages() {
        messages = LowkeyPoll.DummyData().messages
    }
    
    func sendTextMessage(_ message: String) {
        messages.append(Message(type: .text, author: .current, content: message))
    }
    
    func sendPoll(_ poll: LowkeyPoll.ChatPoll) {
        messages.append(Message(type: .poll, author: .current, content: poll))
    }
}
