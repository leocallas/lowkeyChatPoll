//
//  DummyData.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import Foundation

struct DummyData {
    let messages: [Message] = [
        .init(type: .text, author: .init(fullName: "Edwin bass", avatar: .init(named: "edwin")),
              content: "@all Guys, let's eat sushi at the Nozawa Bar."),
        .init(type: .text, author: .init(fullName: "John Austin", avatar: .init(named: "john")),
              content: "good choice. how about everyone else? Any ideas?"),
        .init(type: .text, author: .init(fullName: "Edwin bass", avatar: .init(named: "edwin")),
              content: "Sounds good to me!!!"),
        .init(type: .text, author: .init(fullName: "Edwin bass", avatar: .init(named: "edwin")),
              content: "@Kellyhodges are you in???"),
        .init(type: .text, author: .init(fullName: "Kelley Hodges", avatar: .init(named: "kelley")),
              content: "Nice! 12 ppl in total. Let's gather at the metro station."),
        .init(type: .text, author: .init(fullName: "Jared Phillips", avatar: .init(named: "jared")),
              content: "Okie dokie!!")
    ]
}
