//
//  BaseCellTitleLabel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 12.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

class BaseCellTitleLabel: ExtendableLabel {
    override func setUp() {
        super.setUp()
        font = Theme.Fonts.getFont(ofSize: .large, weight: .medium)
        textColor = Theme.Colors.Texts.primary
        textAlignment = .left
    }
}
