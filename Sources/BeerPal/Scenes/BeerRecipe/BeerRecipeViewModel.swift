//
//  BeerRecipeViewModel.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 19.10.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import struct RxCocoa.Driver
import RxSwift

final class BeerRecipeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    let input: BeerRecipeViewModel.Input
    let output: BeerRecipeViewModel.Output
    
    struct Input {}
    
    struct Output {
        let title: String
        let sections: Driver<[BeerRecipeSection]>
    }
    
    init(from beer: Beer, dependencies: Dependencies) {
        let sections = Observable
            .just(Self.makeRecipeSections(for: beer))
            .asDriver(onErrorJustReturn: [])
        
        self.input = Input()
        self.output = Output(
            title: "How to make it?",
            sections: sections
        )
    }
    
    private static func makeRecipeSections(for beer: Beer) -> [BeerRecipeSection] {
        return [
            BeerRecipeSection(
                header: "🌿 Ingredients",
                items: makeSections(of: beer.ingredients).flatMap { $0.items }.map { BeerRecipeItem.ingredient(name: "‣ " + $0) }
            ),
            makeMethodSection(from: beer.method),
            BeerRecipeSection(
                header: "💡 Tips",
                items: [BeerRecipeItem.tip(content: beer.brewersTips, contributor: beer.contributedBy)]
            ),
            BeerRecipeSection(
                header: "🍽️ Pairing foods",
                items: beer.foodPairing.map { BeerRecipeItem.ingredient(name: "‣ " + $0) }
            )
        ]
    }
    
    private static func makeMethodSection(from method: Beer.Method) -> BeerRecipeSection {
        var steps: [String] = []
        
        for mash in method.mashTemp {
            var mashStep = "Mash in " + mash.temp.description
            
            if let duration = mash.duration {
                mashStep.append(String(format: " for %d min", duration))
            }
            
            steps.append(mashStep)
        }
            
        let fermentationStep = R.string.localizable.beerDetailsMethodFerment() + " " + method.fermentation.temp.description
        steps.append(fermentationStep)
        
        if let twist = method.twist {
            let twistStep = R.string.localizable.beerDetailsMethodTwist() + ": " + twist
            steps.append(twistStep)
        }
        
        return BeerRecipeSection(
            header: "🍺 Method",
            items: steps.enumerated().map { BeerRecipeItem.method(name: $0.element, index: $0.offset + 1) }
        )
    }
    
    #warning("TODO: Make one ingredients section instead of multiple sections")
    private static func makeSections(of ingredients: Beer.Ingredients) -> [Section<String>] {
        var sections = [Section<String>]()
    
        let maltItems = ingredients.malt.map {
            String(format: "%@ %@ %@",
                    $0.amount.description,
                    R.string.localizable.commonOf(),
                    $0.name)
        }
    
            let maltSection = Section<String>(
                name: R.string.localizable.beerDetailsIngredientsMalt(),
                items: maltItems)
    
            let hopItems = ingredients.hops.map {
                String(format: "%@ of %@ %@ (%@)",
                       $0.amount.description,
                       $0.name,
                       $0.attribute.description,
                       $0.add)
            }
    
            let hopSection = Section<String>(
                name: R.string.localizable.beerDetailsIngredientsHops(),
                items: hopItems)
    
            sections.append(contentsOf: [maltSection, hopSection])
    
            if let yeast = ingredients.yeast {
                let yeastSection = Section<String>(
                    name: R.string.localizable.beerDetailsIngredientsYeast(),
                    items: [yeast])
    
                sections.append(yeastSection)
            }
    
            return sections
    }
}

extension BeerRecipeViewModel {
    typealias BrewageMethodStep = String
    typealias Dependencies = HasNetworking ; #warning("TODO: HasStorage")
}

private extension Beer.Measure {
    var description: String {
        if let value = value {
            return value.withoutTrailingZeros() + " " + unit
        } else {
            return ""
        }
    }
}


// avoid unnecessary guards and default values setting
private extension Beer.Attribute {
    var description: String {
        switch self {
        case .aroma, .aromaAlternative:
            return R.string.localizable.beerDetailsAttributeAroma()
        case .bitter, .bittering, .bitterAlternative:
            return R.string.localizable.beerDetailsAttributeBitterness()
        case .flavour, .flavourAlternative:
            return R.string.localizable.beerDetailsAttributeFlavour()
        case .aromaBitter:
            return R.string.localizable.beerDetailsAttributeAromaBitterness()
        case .twist:
            return rawValue
        case .other:
            return ""
        }
    }
}

extension Double {
    func withoutTrailingZeros() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return String(formatter.string(from: number) ?? "")
    }
}
