//
//  Constants.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import Foundation

extension Array {
    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
