//
//  BeerDetailsDescriptionLabel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 28.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import Foundation

final class BeerDetailsDescriptionLabel: ExtendableLabel {
    override func setUp() {
        super.setUp()
        font = .systemFont(ofSize: 15)
        textColor = Theme.Colors.Texts.primary
    }
}
