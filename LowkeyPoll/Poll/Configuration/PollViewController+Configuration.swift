//
//  PollViewController+Configuration.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

extension UIStoryboard {
    func instantiatePollViewController(delegate: PollViewDelegate) -> PollViewController? {
        let storyboard = UIStoryboard(name: "Poll", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PollViewController") as? PollViewController
        viewController?.viewModel = PollViewModel(delegate: delegate, viewModelDelegate: viewController)
        return viewController
    }
}
