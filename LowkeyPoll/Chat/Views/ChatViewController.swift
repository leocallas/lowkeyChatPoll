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

    // MARK: - IBActions

    @IBAction private func menuButtonTapped(_ sender: UIButton) {
        presentPollViewController()
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
        tableView.register(.init(nibName: MessageTableViewCell.typeName, bundle: nil), forCellReuseIdentifier: MessageTableViewCell.typeName)
        tableView.register(.init(nibName: PollMessageTableViewCell.typeName, bundle: nil), forCellReuseIdentifier: PollMessageTableViewCell.typeName)
        tableView.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: .zero, right: .zero)
    }

    private func configureMessageTextField() {
        messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func sendMessage() {
        guard let message = messageTextField.text, !message.isEmpty else { return }
        viewModel.sendTextMessage(message)
        messageTextField.text = nil
        
        updateTableView()
    }

    private func presentPollViewController() {
        if let pollViewController = UIStoryboard().instantiatePollViewController(delegate: self) {
            self.present(pollViewController, animated: true)
        }
    }

    private func updateTableView() {
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
        if let content = viewModel.messages.item(at: indexPath.row) {
            switch content.type {
            case .text:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.typeName, for: indexPath) as? MessageTableViewCell else { return .init() }
                if let content = content as? Message<String> {
                    cell.configure(with: content)
                }
                return cell
            case .poll:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PollMessageTableViewCell.typeName, for: indexPath) as? PollMessageTableViewCell else { return .init() }
                if let content = content as? Message<ChatPoll> {
                    cell.configure(with: content)
                }
                return cell
            }
        }
        
        return .init()
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

// MARK: - PollViewDelegate

extension ChatViewController: PollViewDelegate {
    func createPoll(with poll: ChatPoll) {
        viewModel.sendPoll(poll)
        updateTableView()
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
