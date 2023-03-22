//
//  UIImageView+Extensions.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

extension UIButton {
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.setImage(image, for: .normal)
        }, completion: nil)
    }
}
