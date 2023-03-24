//
//  PollViewModel.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

protocol PollViewModelProtocol {
    var dataSource: [PollTableDataSourceItem] { get }

    var delegate: PollViewDelegate? { get }
    var viewModelDelegate: PollViewModelDelegate? { get }

    func item(at section: Int) -> PollTableDataSourceItem?
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int

    func addOption(at indexPath: IndexPath)
    func removeOption(at index: Int)
    func toggleAnonymous(_ value: Bool)
    func createPoll()
}

protocol PollViewModelDelegate: AnyObject {
    func reload(at indexPath: IndexPath)
}

final class PollViewModel: PollViewModelProtocol {
 
    // MARK: - Properties

    var options: [Option] = []

    var question: String = ""
    var isAnonymous: Bool = false

    var dataSource: [PollTableDataSourceItem] = []

    weak var delegate: PollViewDelegate?
    weak var viewModelDelegate: PollViewModelDelegate?

    init(delegate: PollViewDelegate, viewModelDelegate: PollViewModelDelegate?) {
        self.delegate = delegate
        self.viewModelDelegate = viewModelDelegate
        configureTableViewDataSource()
    }

    // MARK: - Methods

    func configureTableViewDataSource() {
        var dataSource: [PollTableDataSourceItem] = []

        let questionItem = PollQuestionDataItem()
        dataSource.append(questionItem)
        
        let optionItem = PollOptionDataItem(options: options.sorted(by: { $0.index < $1.index }))
        dataSource.append(optionItem)
        
        let addOptionItem = PollAddOptionDataItem()
        dataSource.append(addOptionItem)

        let anonymousSwitcher = PollSwitcherDataItem(model: .init(icon: .init(named: "anonymous"), title: "Anonymous voting", isActive: false))
        let addOptionSwitcher = PollSwitcherDataItem(model: .init(icon: .init(named: "addOption"), title: "Ability to add more options", isActive: false))
        dataSource.append(contentsOf: [anonymousSwitcher, addOptionSwitcher])
        
        self.dataSource = dataSource
    }
    
    func item(at section: Int) -> PollTableDataSourceItem? {
        dataSource.item(at: section)
    }

    func numberOfSections() -> Int {
        dataSource.count
    }

    func numberOfRows(in section: Int) -> Int {
        item(at: section)?.numberOfRows ?? .zero
    }

    func addOption(at indexPath: IndexPath) {
        guard options.count != Constants.pollOptionsLimit else { return }
        options.append(.init(index: options.count, text: ""))
        configureTableViewDataSource()
        viewModelDelegate?.reload(at: indexPath)
    }
    
    func setOptionText(_ text: String, at index: Int) {
        options[index].text = text
    }

    func removeOption(at index: Int) {
        options.remove(at: index)
        configureTableViewDataSource()
    }
    
    func toggleAnonymous(_ value: Bool) {
        isAnonymous = value
    }
    
    func createPoll() {
        let poll = ChatPoll(
            question: question,
            options: options,
            author: isAnonymous ? nil : .current
        )
        delegate?.createPoll(with: poll)
    }
}
