//
//  PollTableDataSource.swift
//  LowkeyPoll
//
//  Created by Lkoberidze on 23.03.23.
//

import Foundation

enum DataItemType {
    case question
    case options
    case addOption
    case switcher
}

protocol PollTableDataSourceItem {
    var type: DataItemType { get }
    var numberOfRows: Int { get }
}

final class PollQuestionDataItem: PollTableDataSourceItem {
    var type: DataItemType = .question
    var numberOfRows: Int = 1
}

final class PollOptionDataItem: PollTableDataSourceItem {
    var type: DataItemType = .options
    var numberOfRows: Int {
        options.count
    }
    
    var options: [Option]
    
    init(options: [Option]) {
        self.options = options
    }
}

final class PollAddOptionDataItem: PollTableDataSourceItem {
    var type: DataItemType = .addOption
    var numberOfRows: Int = 1
}

final class PollSwitcherDataItem: PollTableDataSourceItem {
    var type: DataItemType = .switcher
    var numberOfRows: Int = 1
    
    var model: PollSwitchModel

    init(model: PollSwitchModel) {
        self.model = model
    }
}
