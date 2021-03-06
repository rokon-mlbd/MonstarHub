//
//  ContentsViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.contentCell.identifier

class ContentsViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.rightBarButtonItem = rightBarButton

        tableView.register(R.nib.contentCell)
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ContentsViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = ContentsViewModel.Input(headerRefresh: refresh,
                                            selection: tableView.rx.modelSelected(ContentCellViewModel.self).asDriver(),
                                            openInWebSelection: rightBarButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ContentCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.openContents.drive(onNext: { model in
            viewModel.navigateTo(step: SearchStep.contents(repository: model.repository, content: model.content, ref: model.ref))
        }).disposed(by: rx.disposeBag)

        output.openUrl.filterNil().drive(onNext: { url in
            viewModel.navigateTo(step: SearchStep.webController(url))
        }).disposed(by: rx.disposeBag)

        output.openSource.drive(onNext: { content in
            viewModel.navigateTo(step: SearchStep.source(content: content))
        }).disposed(by: rx.disposeBag)
    }
}
