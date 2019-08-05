//
//  Avaliacao.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import Foundation
import UIKit

struct Valuation: Codable {
    
    let id: Int?
    let user_id: Int
    let weight: Int
    let height: Float
    var imc: Int
    var image: String
    var result: String
    let date: String
    
}
