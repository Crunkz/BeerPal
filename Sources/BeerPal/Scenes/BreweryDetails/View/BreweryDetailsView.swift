//
//  BreweryDetailsView.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 30.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

final class BreweryDetailsView: UIView {
    private let horizontalSpacing: CGFloat = 30.0
    private let verticalSpacing: CGFloat = 24.0
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let breweryImageView = UIImageView()
    private let nameLabel = TitleLabel()
    private let propertiesStackView = UIStackView()
    private let typePropertyLabel = BreweryPropertyLabel()
    private let inBusinessPropertyLabel = BreweryPropertyLabel()
    private let verifiedPropertyLabel = BreweryPropertyLabel()
    private let organicPropertyLabel = BreweryPropertyLabel()
    private let addressPropertyLabel = BreweryPropertyLabel()
    private let phoneNumberPropertyLabel = BreweryPropertyLabel()
    private let descriptionHeaderLabel = HeaderLabel()
    private let descriptionLabel = BeerDetailsDescriptionLabel()
    
    init(using brewery: BreweryDetailsItemViewModel, frame: CGRect = .zero) {
        super.init(frame: frame)
        setUp()
        fill(with: brewery)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func fill(with brewery: BreweryDetailsItemViewModel) {
        nameLabel.text = brewery.name
        setProperty(brewery.type, on: typePropertyLabel)
        setProperty(brewery.inBusiness, on: inBusinessPropertyLabel)
        setProperty(brewery.verified, on: verifiedPropertyLabel)
        setProperty(brewery.organic, on: organicPropertyLabel)
        setProperty(brewery.address, on: addressPropertyLabel)
        setProperty(brewery.phoneNumber, on: phoneNumberPropertyLabel)
        descriptionLabel.text = brewery.description
        descriptionHeaderLabel.isHidden = !(brewery.description?.isEmpty == false)
        breweryImageView.loadImage(from: brewery.imageURLString)
        
        if let url = brewery.websiteURL {
            if #available(iOS 13.0, *) {
                let spacerView = UIView()
                propertiesStackView.addArrangedSubview(spacerView)
                spacerView.snp.makeConstraints { $0.height.equalTo(1) }
                
                let websiteRichLinkView = RichLinkView()
                websiteRichLinkView.loadURL(url)
                propertiesStackView.addArrangedSubview(websiteRichLinkView)
            } else {
                let websiteLabel = BreweryPropertyLabel()
                websiteLabel.text = "🌎 " + url.absoluteString
                propertiesStackView.addArrangedSubview(websiteLabel)
            }
        }
    }
    
    private func setProperty(_ value: String?, on label: UILabel) {
        label.text = value
        label.isHidden = !(value != nil)
    }
}

extension BreweryDetailsView {
    private func setUp() {
        backgroundColor = Theme.Colors.Background.primary
        setUpScrollView()
        setUpContentView()
        setUpBreweryImageView()
        setUpNameLabel()
        setUpPropertiesStackView()
        setUpPropertyLabels()
        setUpDescriptionHeaderLabel()
        setUpDescriptionLabel()
    }
    
    private func setUpScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.width * 0.6)
            make.left.right.bottom.width.equalToSuperview()
        }
    }
    
    private func setUpBreweryImageView() {
        breweryImageView.contentMode = .scaleAspectFill
        breweryImageView.clipsToBounds = true
        scrollView.insertSubview(breweryImageView, belowSubview: contentView)
        
        breweryImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.snp.top).priority(.high)
        }
    }
    
    private func setUpNameLabel() {
        contentView.addSubview(nameLabel)
            
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalSpacing)
            make.top.equalToSuperview().offset(verticalSpacing)
            make.right.equalToSuperview().inset(horizontalSpacing)
        }
    }
    
    private func setUpPropertiesStackView() {
        propertiesStackView.axis = .vertical
        propertiesStackView.distribution = .fill
        propertiesStackView.spacing = verticalSpacing * 0.6
        contentView.addSubview(propertiesStackView)
        
        propertiesStackView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(verticalSpacing)
            make.left.right.equalTo(nameLabel)
        }
    }
    
    private func setUpPropertyLabels() {
        [typePropertyLabel, inBusinessPropertyLabel, verifiedPropertyLabel, organicPropertyLabel, addressPropertyLabel, phoneNumberPropertyLabel].forEach { (propertyLabel) in
            propertiesStackView.addArrangedSubview(propertyLabel)
        }
    }
    
    private func setUpDescriptionHeaderLabel() {
        descriptionHeaderLabel.text = R.string.localizable.beerDetailsDescriptionHeader()
        contentView.addSubview(descriptionHeaderLabel)
        descriptionHeaderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(propertiesStackView.snp.bottom).offset(verticalSpacing * 1.5)
            make.right.equalToSuperview().inset(horizontalSpacing)
        }
    }
    
    private func setUpDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(descriptionHeaderLabel)
            make.top.equalTo(descriptionHeaderLabel.snp.bottom).offset(verticalSpacing * 0.6)
            make.bottom.equalToSuperview().inset(verticalSpacing)
        }
    }
}

private class BreweryPropertyLabel: ExtendableLabel {
    override func setUp() {
        super.setUp()
        font = Theme.Fonts.getFont(ofSize: .small, weight: .medium)
    }
}
