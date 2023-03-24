//
//  PollOptionTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

protocol PollOptionTableViewCellDelegate: AnyObject {
    func textFieldDidChange(_ textField: UITextField, cell: PollOptionTableViewCell)
    func optionDidRemove(_ cell: PollOptionTableViewCell)
}

final class PollOptionTableViewCell: UITableViewCell, NameDescribable {

    // MARK: - IBOutlets

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var removeButtonView: UIView!

    // MARK: - Properties

    weak var delegate: PollOptionTableViewCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
        removeButtonView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }

    // MARK: - IBActions

    @IBAction private func removeButtonTapped(_ sender: UIButton) {
        delegate?.optionDidRemove(self)
    }

    // MARK: - Methods

    func configure(with delegate: PollOptionTableViewCellDelegate) {
        self.delegate = delegate
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChange(textField, cell: self)
    }

    private func configureTextField() {
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}
