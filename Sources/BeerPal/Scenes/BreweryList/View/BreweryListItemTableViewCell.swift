//
//  BreweryListItemTableViewCell.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 12.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

final class BreweryListItemTableViewCell: UITableViewCell {
    private let horizontalSpacing: CGFloat = 20
    private let verticalSpacing: CGFloat = 20
    
    private var contentContainerView = UIView()
    private var logoImageView = UIImageView()
    private var nameLabel = BaseCellTitleLabel()
    private var establishmentDateLabel = BaseCellSubtitleLabel()
    private var tagsStackView = UIStackView()
    
    var item: Brewery? {
        didSet { refresh() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
    
    private func refresh() {
        nameLabel.text = item?.name
        establishmentDateLabel.text = item?.established
        setTags(for: item)
        logoImageView.loadImage(from: item?.images?.medium)
    }
    
    private func setTags(for brewery: Brewery?) {
        tagsStackView.removeFromSuperview()
        
        let tags = [
            (canBeAdded: brewery?.isInBusiness, title: R.string.localizable.breweryListItemTagInBusiness(), color: UIColor.systemBlue),
            (canBeAdded: brewery?.isOrganic, title: R.string.localizable.breweryListItemTagOrganic(), color: UIColor.systemGreen),
            (canBeAdded: brewery?.isVerified, title: R.string.localizable.breweryListItemTagVerified(), color: UIColor.systemOrange),
        ]
        
        tags
            .filter { $0.canBeAdded == true }
            .forEach { (_, title, color) in
                let tagView = TagView(title: title, color: color)
                tagsStackView.addArrangedSubview(tagView)
            }
    }
}

extension BreweryListItemTableViewCell {
    private func setUp() {
        setUpContentContainerView()
        setUpLogoImageView()
        setUpNameLabel()
        setUpEstablishmentDateLabel()
        setUpTagsStackView()
    }
    
    private func setUpContentContainerView() {
        addSubview(contentContainerView)
        
        contentContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalInset)
            make.top.equalToSuperview().offset(verticalInset)
            make.right.equalToSuperview().inset(horizontalInset)
            make.bottom.equalToSuperview().inset(verticalInset)
        }
    }
    
    private func setUpLogoImageView() {
        contentContainerView.backgroundColor = Theme.Colors.Background.secondary
        contentContainerView.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalSpacing)
            make.top.equalToSuperview().offset(verticalSpacing)
            make.width.height.equalTo(60)
        }
    }
    
    private func setUpNameLabel() {
        contentContainerView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(logoImageView.snp.right).offset(horizontalSpacing * 0.5)
            make.top.equalTo(logoImageView).offset(verticalSpacing * 0.5)
            make.right.equalToSuperview().inset(horizontalSpacing)
        }
    }
    
    private func setUpEstablishmentDateLabel() {
        contentContainerView.addSubview(establishmentDateLabel)
         
        establishmentDateLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(verticalSpacing * 0.25)
        }
    }
    
    private func setUpTagsStackView() {
        tagsStackView.axis = .horizontal
        tagsStackView.spacing = horizontalSpacing * 0.5
        contentContainerView.addSubview(tagsStackView)
        
        tagsStackView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(establishmentDateLabel.snp.bottom).offset(verticalSpacing * 0.75)
            make.right.lessThanOrEqualTo(nameLabel)
            make.bottom.equalToSuperview().inset(verticalSpacing)
        }
    }
}
