//
//  ChatViewController.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

final class ChatViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendMessageButton: UIButton!

    // MARK: - Properties
    
    var viewModel: ChatViewModel = ChatViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToShowKeyboardNotifications()
        configureTableView()
        configureMessageTextField()
        viewModel.loadMessages()
    }

    @IBAction private func sendMessageButtonTapped(_ sender: UIButton) {
        sendMessage()
    }

    // MARK: - Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Private Methods

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: CellIdentifiers.messageCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.messageCell)
        tableView.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: .zero, right: .zero)
    }

    private func configureMessageTextField() {
        messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func sendMessage() {
        guard let message = messageTextField.text else { return }
        viewModel.sendMessage(message)
        messageTextField.text = nil
        
        // Animated adding message
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: .zero)
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.messageCell, for: indexPath) as? MessageTableViewCell else { return .init() }
        if let message = viewModel.messages.item(at: indexPath.row) {
            cell.configure(with: message)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendMessage()
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        sendMessageButton.setImage((textField.text?.isEmpty ?? false) ? UIImage(named: "camera") : UIImage(named: "send"), animated: true)
    }
}

// MARK: - Keyboard State

extension ChatViewController {
    private func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardHeight = keyboardSize?.cgRectValue.height {
            bottomViewBottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
        }
        
        if let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomViewBottomConstraint.constant = 0
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ChatViewController {
    struct CellIdentifiers {
        static let messageCell = "MessageTableViewCell"
    }
}

