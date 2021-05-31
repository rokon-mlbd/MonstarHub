//
//  CommitCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class CommitCellViewModel: DefaultTableViewCellViewModel {

    let commit: Commit

    let userSelected = PublishSubject<User>()

    init(with commit: Commit) {
        self.commit = commit
        super.init()
        title.accept(commit.commit?.message)
        detail.accept(commit.commit?.committer?.date?.toRelative())
        secondDetail.accept(commit.sha?.slicing(from: 0, length: 7))
        imageUrl.accept(commit.committer?.avatarUrl)
        badge.accept(R.image.icon_cell_badge_commit()?.template)
        badgeColor.accept(UIColor.Material.green)
    }
}
