//
//  DummyData.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import Foundation

struct DummyData {
    let messages: [Message] = [
        .init(author: "Edwin bass", authorImage: .init(named: "edwin"), message: "@all Guys, let's eat sushi at the Nozawa Bar."),
        .init(author: "John Austin", authorImage: .init(named: "john"), message: "good choice. how about everyone else? Any ideas?"),
        .init(author: "Edwin bass", authorImage: .init(named: "edwin"), message: "Sounds good to me!!!"),
        .init(author: "Edwin bass", authorImage: .init(named: "edwin"), message: "@Kellyhodges are you in???"),
        .init(author: "Kelley Hodges", authorImage: .init(named: "kelley"), message: "Nice! 12 ppl in total. Let's gather at the metro station."),
        .init(author: "Jared Phillips", authorImage: .init(named: "jared"), message: "Okie dokie!!")
    ]
}
