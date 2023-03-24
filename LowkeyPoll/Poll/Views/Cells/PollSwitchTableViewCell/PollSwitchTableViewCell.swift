//
//  PollSwitchTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

final class PollSwitchTableViewCell: UITableViewCell, NameDescribable {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var switchTitleLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Methods

    func configure(with model: PollSwitchModel) {
        iconImageView.image = model.icon
        switchTitleLabel.text = model.title
        switcher.isOn = model.isActive
    }

}
