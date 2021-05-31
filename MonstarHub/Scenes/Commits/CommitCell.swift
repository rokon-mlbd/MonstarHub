//
//  CommitCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift

class CommitCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? CommitCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.commit.committer }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
