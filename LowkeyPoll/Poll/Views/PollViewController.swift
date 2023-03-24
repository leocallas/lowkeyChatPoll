//
//  PollViewController.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 22.03.23.
//

import UIKit

final class PollViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var createButton: UIButton!
    
    // MARK: - Properties

    var viewModel: PollViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        checkForCanCreatePoll()
    }

    // MARK: - IBActions

    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        viewModel?.createPoll()
        dismiss(animated: true)
    }

    // MARK: - Private Methods

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: PollQuestionTableViewCell.typeName, bundle: nil),
                           forCellReuseIdentifier: PollQuestionTableViewCell.typeName)
        tableView.register(.init(nibName: PollSwitchTableViewCell.typeName, bundle: nil),
                           forCellReuseIdentifier: PollSwitchTableViewCell.typeName)
        tableView.register(.init(nibName: PollOptionTableViewCell.typeName, bundle: nil),
                           forCellReuseIdentifier: PollOptionTableViewCell.typeName)
        tableView.register(.init(nibName: PollAddOptionTableViewCell.typeName, bundle: nil),
                           forCellReuseIdentifier: PollAddOptionTableViewCell.typeName)
        tableView.register(.init(nibName: PollOptionTableViewSectionHeaderView.typeName, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: PollOptionTableViewSectionHeaderView.typeName)
    }

    private func checkForCanCreatePoll() {
        let canCreate = (viewModel?.options.count ?? .zero) > .zero && !(viewModel?.question.isEmpty ?? false) && !(viewModel?.options.contains(where: { $0.text.isEmpty }) ?? false)
        createButton.isEnabled = canCreate
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PollViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? .zero
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section) ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataItem = viewModel?.item(at: indexPath.section) else { return .init() }
        
        switch dataItem.type {
        case .question:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PollQuestionTableViewCell.typeName, for: indexPath) as? PollQuestionTableViewCell else { return .init() }
            cell.configure(delegate: self)
            return cell
        case .options:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PollOptionTableViewCell.typeName, for: indexPath) as? PollOptionTableViewCell else { return .init() }
            cell.configure(with: self)
            return cell
        case .addOption:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PollAddOptionTableViewCell.typeName, for: indexPath) as? PollAddOptionTableViewCell else { return .init() }
            return cell
        case .switcher:
            guard let model = (dataItem as? PollSwitcherDataItem)?.model, let cell = tableView.dequeueReusableCell(withIdentifier: PollSwitchTableViewCell.typeName, for: indexPath) as? PollSwitchTableViewCell else { return .init() }
            cell.configure(with: model)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataItem = viewModel?.item(at: indexPath.section), dataItem.type == .addOption else { return }
        viewModel?.addOption(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataItem = viewModel?.item(at: section), dataItem.type == .options else { return .init() }

        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PollOptionTableViewSectionHeaderView.typeName) as? PollOptionTableViewSectionHeaderView {
            headerView.setCount(viewModel?.options.count ?? .zero)
            return headerView
        }

        return .init()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataItem = viewModel?.item(at: section), dataItem.type == .options else { return .leastNonzeroMagnitude }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let dataItem = viewModel?.item(at: section), dataItem.type == .addOption else { return .leastNonzeroMagnitude }
        return 30
    }
}

// MARK: - PollOptionTableViewCellDelegate

extension PollViewController: PollOptionTableViewCellDelegate {
    func optionDidRemove(_ cell: PollOptionTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel?.removeOption(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            (tableView.headerView(forSection: indexPath.section) as? PollOptionTableViewSectionHeaderView)?.setCount(viewModel?.options.count ?? .zero)
            checkForCanCreatePoll()
        }
    }

    func textFieldDidChange(_ textField: UITextField, cell: PollOptionTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel?.setOptionText(textField.text ?? "", at: indexPath.row)
            checkForCanCreatePoll()
        }
    }
}

// MARK: - PollQuestionTableViewCellDelegate

extension PollViewController: PollQuestionTableViewCellDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.question = textView.text
        checkForCanCreatePoll()
    }
    
    func textViewShouldChangeHeight(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
}

// MARK: - PollViewModelDelegate

extension PollViewController: PollViewModelDelegate {
    func reload(at indexPath: IndexPath) {
        // Diffable datasource would be more dynamic solution
        tableView.insertRows(at: [.init(row: (viewModel?.options.count ?? .zero) - 1, section: indexPath.section - 1)], with: .fade)
        (tableView.headerView(forSection: indexPath.section - 1) as? PollOptionTableViewSectionHeaderView)?.setCount(viewModel?.options.count ?? .zero)
        checkForCanCreatePoll()
    }
}
