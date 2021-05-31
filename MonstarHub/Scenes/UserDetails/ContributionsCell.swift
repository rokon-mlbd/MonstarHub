//
//  ContributionsCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift

class ContributionsCell: DefaultTableViewCell {

    lazy var containerStackView: StackView = {
        let views: [UIView] = [self.stackView, self.contributionsView]
        let view = StackView(arrangedSubviews: views)
        view.spacing = inset
        view.axis = .vertical
        return view
    }()

    lazy var contributionsView: ContributionsView = {
        let view = ContributionsView()
        return view
    }()

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.cornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        detailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
        stackView.snp.removeConstraints()
        containerView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset)
        })

        themeService.rx
            .bind({ $0.secondary }, to: [rightImageView.rx.tintColor])
            .disposed(by: rx.disposeBag)
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ContributionsCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        viewModel.contributionCalendar.bind(to: contributionsView.calendar).disposed(by: cellDisposeBag)

        viewModel.contributionCalendar.map { $0 == nil }.bind(to: contributionsView.rx.isHidden).disposed(by: cellDisposeBag)
    }
}
