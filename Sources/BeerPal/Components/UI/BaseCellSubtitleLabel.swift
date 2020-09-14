//
//  BaseCellSubtitleLabel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 12.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

class BaseCellSubtitleLabel: BaseLabel {
    override func setUp() {
        font = Theme.Fonts.getFont(ofSize: .xxSmall, weight: .light)
        textColor = Theme.Colors.Texts.secondary
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}
