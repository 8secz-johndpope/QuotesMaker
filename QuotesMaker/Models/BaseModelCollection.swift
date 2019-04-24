//
//  BaseModelCollection.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 24/04/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import Foundation


typealias EquaCodable = Codable & Equatable

struct BaseModelCollection<T:EquaCodable>{
    
    private var _container:[T] = []
    
    mutating func append(_ model:T){
        if _container.contains(model){
            return
        }
        _container.append(model)
    }
    
    /**
     * Not very Efficient. use method append instead
     */
    mutating func update(model:T){
        let index = _container.firstIndex(of: model)
        if index != nil{
            _container.remove(at: index!)
            _container.insert(model, at: index!)
        }
        _container.append(model)
    }
    
    var items:[T]{
        return _container
    }
    
    mutating func pop()->T?{
        return _container.popLast()
    }
    
    var isMulti:Bool{
        return _container.count > 1
    }
    
    var isEmpty:Bool{
        return _container.isEmpty
    }
}

extension BaseModelCollection:Codable{}


extension BaseModelCollection:ExpressibleByArrayLiteral{
    
    
    init(arrayLiteral elements: T...) {
        var collecton = BaseModelCollection()
        elements.forEach{
            collecton.append($0)
        }
        
    }
}
