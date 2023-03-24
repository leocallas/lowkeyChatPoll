//
//  PollMessageTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 24.03.23.
//

import UIKit

final class PollMessageTableViewCell: UITableViewCell, NameDescribable {

    // MARK: - IBOutlets

    @IBOutlet private weak var votesLabel: UILabel!
    @IBOutlet private weak var pollTypeLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var authorImageVew: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var optionsStackView: UIStackView!

    // MARK: - Properties

    private let optionViewHeight: CGFloat = 45

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Methods

    func configure(with message: Message<ChatPoll>) {
        authorNameLabel.text = message.author.fullName
        authorImageVew.image = message.author.avatar
        questionLabel.text = message.content.question

        message.content.options.forEach { option in
            optionsStackView.addArrangedSubview(optionView(option: option))
        }
    }
    
    private func optionView(option: Option) -> UIView {
        let optionView = UIView(frame: .init(x: .zero,
                                             y: .zero,
                                             width: optionsStackView.frame.width,
                                             height: optionViewHeight))
        optionView.heightAnchor.constraint(equalToConstant: optionViewHeight).isActive = true
        optionView.backgroundColor = .darkBlue
        optionView.layer.cornerRadius = 15
        optionView.tag = option.index

        let textLabel = UILabel(frame: .init(x: 15,
                                             y: .zero,
                                             width: optionsStackView.frame.width - 30,
                                             height: optionViewHeight))
        textLabel.widthAnchor.constraint(equalToConstant: optionView.frame.width - 30).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: optionViewHeight).isActive = true
        textLabel.text = option.text
        textLabel.textColor = .white
        
        optionView.addSubview(textLabel)
        
        let tapGestureRecognizer = TapGestureRecognizer(target: self, action: #selector(optionTapped(sender:)))
        tapGestureRecognizer.option = option
        optionView.addGestureRecognizer(tapGestureRecognizer)
        
        return optionView
    }

    @objc private func optionTapped(sender: TapGestureRecognizer) {
        votesLabel.text = "\(1)"
        optionsStackView.arrangedSubviews.forEach { view in
            if view.tag != sender.option?.index {
                view.alpha = 0.6
            } else {
                view.alpha = 1
            }
        }
    }

    final class TapGestureRecognizer: UITapGestureRecognizer {
        var option: Option?
        var content: ChatPoll?
    }
}
