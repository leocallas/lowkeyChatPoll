//
//  Option.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

struct Option {
    let index: Int
    var text: String
    
    mutating func setQuestion(_ question: String) {
        self.text = question
    }
}
