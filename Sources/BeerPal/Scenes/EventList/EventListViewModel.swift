//
//  EventListViewModel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 19.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import RxSwift
import RxCocoa

final class EventListViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let repository: EventListRepository
    private let stateManager: DataStateManager
    
    let input: EventListViewModel.Input
    let output: EventListViewModel.Output
    
    struct Input {
        let fetch = PublishRelay<Void>()
        let selectedModel = PublishRelay<EventListItemViewModel>()
    }
    
    struct Output {
        let title = R.string.localizable.eventListTitle()
        var state: Driver<DataState>
        var endRefreshing: Driver<Void>
        var items: Driver<[EventListItemViewModel]>
    }
    
    init(dependencies: Dependencies) {
        let stateManager = DataStateManager()
        let repository = EventListRepository(networkingService: dependencies.networkingService)
        self.input = Input()
        
        let executeFetchRequest: Observable<[EventListItemViewModel]> = Observable.create { (observer) -> Disposable in
            stateManager.update(.loading)
            
            repository.fetchEventList { (result) in
                switch result {
                case .success(let response):
                    stateManager.update(response.events.isEmpty ? .empty("") : .loaded)
                    observer.onNext(response.events.map { EventListItemViewModel(with: $0) })
                    observer.onCompleted()
                case .failure(let error):
                    stateManager.update(.error(error.localizedDescription))
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        let response = input.fetch
            .startWith(())
            .flatMapLatest { executeFetchRequest.materialize() }
            .share()
        
        let endRefreshing = response
            .flatMapLatest { _ in Observable.just(()) }
            .asDriver(onErrorJustReturn: ())
        
        self.stateManager = stateManager
        self.repository = repository
        self.output = Output(
            state: stateManager.currentState,
            endRefreshing: endRefreshing,
            items: response.elements.asDriver(onErrorJustReturn: [])
        )
    }
}

extension EventListViewModel: StateManaging, DataReloading {
    var currentState: Driver<DataState> {
        return output.state
    }
    
    func reloadData() {
        input.fetch.accept(())
    }
}

extension EventListViewModel {
    typealias Dependencies = HasNetworking
}
