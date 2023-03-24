//
//  PollQuestionTableViewCell.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import UIKit

protocol PollQuestionTableViewCellDelegate: AnyObject {
    func textViewDidChange(_ textView: UITextView)
    func textViewShouldChangeHeight(_ textView: UITextView)
}

final class PollQuestionTableViewCell: UITableViewCell, NameDescribable {

    // MARK: - IBOutlets

    @IBOutlet private weak var textLimitCountLabel: UILabel!
    @IBOutlet private(set) weak var textView: UITextView!
    
    // MARK: - Properties

    weak var delegate: PollQuestionTableViewCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Methods

    func configure(delegate: PollQuestionTableViewCellDelegate) {
        self.delegate = delegate
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.text = "Ask a question"
        textView.textColor = .secondary

        textLimitCountLabel.text = "\(textView.textColor != .secondary ? textView.text.count : .zero)/\(Constants.pollQuestionCharacterLimit)"
    }
}

// MARK: - UITextViewDelegate

extension PollQuestionTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count

        textLimitCountLabel.text = "\(textView.textColor != .secondary ? numberOfChars : .zero)/\(Constants.pollQuestionCharacterLimit)"

        return numberOfChars < Constants.pollQuestionCharacterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        if size.height != newSize.height {
            delegate?.textViewShouldChangeHeight(textView)
        }
        
        delegate?.textViewDidChange(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondary {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ask a question"
            textView.textColor = .secondary
        }
    }
}
