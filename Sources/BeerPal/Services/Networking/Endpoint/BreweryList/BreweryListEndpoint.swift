//
//  BreweryListEndpoint.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 11.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import Foundation

extension API {
    static func breweryList() -> Endpoint<BreweryListResponseModel> {
        let url = URLBuilder()
        .set(path: "breweries")
        .build()!
        
        return Endpoint(method: .get, url: url)
    }
}
