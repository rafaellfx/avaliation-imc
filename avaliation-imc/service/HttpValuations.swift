//
//  HttpService.swift
//  Projeto Final
//
//  Created by Rafael lima felix on 18/05/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import Foundation

struct HttpValuations {

    private static let pathServer = "http://rafaellfx.com.br/api-ios/valuations/"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.waitsForConnectivity = true
        
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    static func loadValuations(_ userId:Int , completi: @escaping ([Valuation]?) -> Void){
        
        guard let url = URL(string: pathServer + String(userId) + ".json") else { return }
    
        let task  = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                if httpResponse.statusCode == 200 {
                    guard let data = data else { return }
                    
                    do {
                        let valuations = try JSONDecoder().decode([Valuation].self, from: data)
                        completi(valuations)
                        
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

    static func save(valuation: Valuation, completi: @escaping (Bool)-> Void){
        
        applayOperation(valuation: valuation, operation: .save, completi: completi)
    }
    
    static func delete(valuation: Valuation, completi: @escaping (Bool)-> Void){
        
        applayOperation(valuation: valuation, operation: .delete, completi: completi)
    }
    
    private static func applayOperation(valuation: Valuation, operation:Operation, completi: @escaping (Bool)-> Void){
        
        var endPoint = ".json"
        if let path = valuation.id {
            endPoint = String(path) + ".json"
        }
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
            let json = try JSONEncoder().encode(valuation)
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

enum Operation {
    
    case save
    case delete
}
