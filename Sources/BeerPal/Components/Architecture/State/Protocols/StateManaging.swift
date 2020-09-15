//
//  StateManaging.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 01.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import RxCocoa

protocol StateManaging {
    var currentState: Driver<DataState> { get }
}
