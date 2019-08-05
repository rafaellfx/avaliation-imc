//
//  HttpService.swift
//  Projeto Final
//
//  Created by Rafael lima felix on 18/05/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import Foundation

struct HttpUsers {
    
    private static let pathServer = "http://localhost/api-ios/users.json"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.waitsForConnectivity = true
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    static func loadUsers(completi: @escaping ([User]?) -> Void ){
        
        guard let url = URL(string: pathServer + ".json") else { return }
    
        let task  = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                if httpResponse.statusCode == 200 {
                    guard let data = data else { return }
                    
                    do {
                        let users = try JSONDecoder().decode([User].self, from: data)
                        completi(users)
                    }catch{
                        print("Erro \(error)")
                        completi(nil)
                    }
                }
            }else{
                print(error!)
            }
        }
        
        task.resume()
    }
    
    static func delete(user: User, completi: @escaping (Bool)-> Void){
        
        applayOperation(user: user, operation: .delete, completi: completi)
    }
    
    private static func applayOperation(user: User, operation: Operation, completi: @escaping (Bool)-> Void){
        
       
        let endPoint = String(user.id) + ".json"
       
        guard let url = URL(string: pathServer + endPoint) else {
            completi(false)
            return
        }
        var request = URLRequest(url: url)
        
        var httpMethod: String = ""
        
        switch operation {
        case .save:
            httpMethod = "POST"
        case .delete:
            httpMethod = "DELETE"
        }
        
        request.httpMethod = httpMethod
        do{
            let json = try JSONEncoder().encode(user)
            request.httpBody = json
        }catch{
            print("Erro \(error)")
            completi(false)
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completi(false)
                    return
                }
                completi(true)
            }else{
                completi(false)
            }
        }
        task.resume()
    }

}

