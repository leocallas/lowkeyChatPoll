//
//  PollOptionTableViewSectionHeaderView.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

final class PollOptionTableViewSectionHeaderView: UITableViewHeaderFooterView, NameDescribable {

    // MARK: - IBOutlets

    @IBOutlet private weak var optionsCounterLabel: UILabel!

    // MARK: - Methods

    func setCount(_ optionsCount: Int) {
        optionsCounterLabel.text = "\(optionsCount)/\(Constants.pollOptionsLimit)"
    }
}
