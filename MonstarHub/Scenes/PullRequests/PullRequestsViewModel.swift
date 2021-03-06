//
//  PullRequestsViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class PullRequestsViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<PullRequestSegments>
        let selection: Driver<PullRequestCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[PullRequestCellViewModel]>
        let pullRequestSelected: Driver<(repository: Repository, pullRequest: PullRequest)>
        let userSelected: Driver<User>
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<PullRequestSegments>(value: .open)
    let userSelected = PublishSubject<User>()
    typealias Services = AppServices
    private let services: Services

    init(repository: Repository, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[PullRequestCellViewModel]>(value: [])

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[PullRequestCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
        .subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[PullRequestCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
        .subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: rx.disposeBag)

        let navigationTitle = repository.map({ (repository) -> String in
            return repository.fullname ?? ""
        }).asDriver(onErrorJustReturn: "")

        let pullRequestSelected = input.selection.map { cell -> (repository: Repository, pullRequest: PullRequest) in
            return (self.repository.value, cell.pullRequest)
        }

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      pullRequestSelected: pullRequestSelected,
                      userSelected: userDetails)
    }

    func request() -> Observable<[PullRequestCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let state = segment.value.state.rawValue
        return services.gitHubUseCase
            .pullRequests(fullname: fullname, state: state, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (pullRequest) -> PullRequestCellViewModel in
                let viewModel = PullRequestCellViewModel(with: pullRequest)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })}
    }
}
