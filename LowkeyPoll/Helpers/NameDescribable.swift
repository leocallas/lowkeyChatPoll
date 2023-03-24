//
//  NameDescribable.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}
