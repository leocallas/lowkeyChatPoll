//
//  MessageTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

final class MessageTableViewCell: UITableViewCell, NameDescribable {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var authorFullNameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var authorImageView: UIImageView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Methods

    func configure(with message: Message<String>) {
        self.authorFullNameLabel.text = message.author.fullName

        self.messageLabel.text = message.content
        messageLabel.detectMentions()
        
        self.authorImageView.image = message.author.avatar
    }
    
}
