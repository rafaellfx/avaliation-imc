//
//  Usuario.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import Foundation

struct User: Codable , Equatable{
    
    let id: Int
    let name: String
    let cpf: String
    let image: String
   
    
    static func ==(first: User, second: User)->Bool{
        
        return first.name == second.name && first.cpf == second.cpf
    }

}
