//
//  PollVewModelTests.swift
//  LowkeyPollTests
//
//  Created by Lkoberidze on 24.03.23.
//

import XCTest
@testable import LowkeyPoll

final class PollVewModelTests: XCTestCase {

    var sut: PollViewModelProtocol!

    override func setUpWithError() throws {
        sut = MockPollViewModel()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialDataSourceLoaded() {
        XCTAssertTrue(!sut.dataSource.isEmpty)
    }

    func testItemAtIndex() throws {
        let itemAtLastSection = LowkeyPoll.PollAddOptionDataItem()
        sut.dataSource.append(itemAtLastSection)
        XCTAssertEqual(sut.item(at: sut.dataSource.count - 1)?.uuid, itemAtLastSection.uuid)
    }

    func testNumberOfSections() throws {
        let oldDataSourceCount = sut.dataSource.count
        let item = LowkeyPoll.PollQuestionDataItem()
        sut.dataSource.append(item)
        XCTAssertNotEqual(oldDataSourceCount, sut.numberOfSections())
    }

    func testSetOptionText() throws {
        let options = [Option(index: .zero, text: ""), Option(index: 1, text: "")]
        sut.options.append(contentsOf: options)
        let newText = "new text"
        sut.setOptionText("new text", at: options.last?.index ?? .zero)
        XCTAssertEqual(newText, sut.options.last?.text)
    }

    func testNumberOfRowsInSection() throws {
        let options = [Option(index: .zero, text: ""), Option(index: 1, text: "")]
        let item = LowkeyPoll.PollOptionDataItem(options: options)
        sut.dataSource.append(item)
        XCTAssertEqual(item.options.count, sut.numberOfRows(in: sut.dataSource.count - 1))
    }

    func testAddOption() throws {
        sut.addOption(at: .init(row: .zero, section: sut.dataSource.count - 1))
        XCTAssertEqual(sut.options.count, 1)
    }

    func testRemoveOption() throws {
        let options = [Option(index: .zero, text: ""), Option(index: 1, text: "")]
        sut.options = options
        sut.removeOption(at: .zero)
        XCTAssertEqual(sut.options.count, 1)
    }

    func testAddOptionIsOverLimit() throws {
        var options: [Option] = []
        for i in 0..<8 {
            options.append(.init(index: i, text: "i: \(i)"))
        }

        sut.options = options
        
        sut.addOption(at: .init(row: .zero, section: sut.dataSource.count - 1))
        XCTAssertEqual(Constants.pollOptionsLimit, sut.options.count)
    }
}

final class MockPollViewModel: PollViewModelProtocol {
    var dataSource: [any LowkeyPoll.PollTableDataSourceItem] = []
    var options: [Option] = []
    var question: String = ""

    init() {
        configureTableViewInitialDataSource()
    }

    func configureTableViewInitialDataSource() {
        var dataSource: [any LowkeyPoll.PollTableDataSourceItem] = []

        let questionItem = LowkeyPoll.PollQuestionDataItem()
        dataSource.append(questionItem)
        
        let optionItem = LowkeyPoll.PollOptionDataItem(options: options.sorted(by: { $0.index < $1.index }))
        dataSource.append(optionItem)
        
        let addOptionItem = LowkeyPoll.PollAddOptionDataItem()
        dataSource.append(addOptionItem)

        let anonymousSwitcher = LowkeyPoll.PollSwitcherDataItem(model: .init(icon: .init(named: "anonymous"), title: "Anonymous voting", isActive: false))
        let addOptionSwitcher = LowkeyPoll.PollSwitcherDataItem(model: .init(icon: .init(named: "addOption"), title: "Ability to add more options", isActive: false))
        dataSource.append(contentsOf: [anonymousSwitcher, addOptionSwitcher])

        self.dataSource = dataSource
    }

    func item(at section: Int) -> (any PollTableDataSourceItem)? {
        dataSource.item(at: section)
    }
    
    func numberOfSections() -> Int {
        dataSource.count
    }
    
    func setOptionText(_ text: String, at index: Int) {
        options[index].text = text
    }

    func numberOfRows(in section: Int) -> Int {
        item(at: section)?.numberOfRows ?? .zero
    }

    func addOption(at indexPath: IndexPath) {
        guard options.count != LowkeyPoll.Constants.pollOptionsLimit else { return }
        options.append(.init(index: options.count, text: ""))
    }
    
    func removeOption(at index: Int) {
        options.remove(at: index)
    }
}
