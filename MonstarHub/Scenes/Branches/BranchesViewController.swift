//
//  BranchesViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.branchCell.identifier

class BranchesViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(R.nib.branchCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? BranchesViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = BranchesViewModel.Input(headerRefresh: refresh,
                                            footerRefresh: footerRefreshTrigger,
                                            selection: tableView.rx.modelSelected(BranchCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: BranchCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        viewModel.branchSelected.subscribe(onNext: { [weak self] (_) in
//            self?.navigator.pop(sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
