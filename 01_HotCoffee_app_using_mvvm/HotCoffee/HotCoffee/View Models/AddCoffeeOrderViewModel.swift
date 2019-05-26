//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by chu on 2019/05/27.
//  Copyright © 2019 chu. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeSize.allCases.map { $0.rawValue.capitalized }
    }
}
