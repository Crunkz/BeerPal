//
//  BaseCellTitleLabel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 12.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

class BaseCellTitleLabel: BaseLabel {
    override func setUp() {
        font = Theme.Fonts.getFont(ofSize: .xSmall, weight: .medium)
        textColor = Theme.Colors.Texts.primary
        textAlignment = .left
        numberOfLines = 0
    }
}
