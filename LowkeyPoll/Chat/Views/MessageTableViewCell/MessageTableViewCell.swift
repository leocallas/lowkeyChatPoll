//
//  MessageTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var authorFullNameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var authorImageView: UIImageView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        authorImageView.layer.cornerRadius = 17
    }

    // MARK: - Methods

    func configure(with message: Message) {
        self.authorFullNameLabel.text = message.author

        self.messageLabel.text = message.message
        messageLabel.detectMentions()
        
        self.authorImageView.image = message.authorImage
    }
    
}
