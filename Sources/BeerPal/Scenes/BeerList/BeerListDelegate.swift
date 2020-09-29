//
//  BeerListDelegate.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 25.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import Foundation

protocol BeerListDelegate: class {
    func didSelect(_ beer: Beer)
}
