//
//  PollViewDelegate.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

protocol PollViewDelegate: AnyObject {
    func createPoll(with poll: ChatPoll)
}
