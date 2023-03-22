//
//  UILabel+Extensions.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

extension UILabel {

    func detectMentions() {
        let nsText = NSString(string: self.text ?? "")

        let attrString = NSMutableAttributedString()
        attrString.setAttributedString(self.attributedText ?? .init(string: ""))

        for word in nsText.components(separatedBy: " ") {
            if word.count < 3 {
                continue
            }

            if word.hasPrefix("@") {
                let matchRange:NSRange = nsText.range(of: word as String)
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                } else {
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }

            }
        }

        self.attributedText = attrString
    }
}
