//
//  Events.swift
//  diary
//
//  Created by Glip on 22.03.2021.
//

import Foundation

class Events {
    let id: Int
    let date_start: Double
    let date_finish: Double
    let name: String
    let description: String
    
    init(json: Dictionary<String, Any>) {
        id = json["id"] as! Int
        date_start = json["date_start"] as! Double
        date_finish = json["date_finish"] as! Double
        name = json["name"] as! String
        description = json["description"] as! String
    }
    
    func toJson() -> Dictionary<String, Any> {
        var json = Dictionary<String, Any>()
        json["id"] = id
        json["date_start"] = date_start
        json["date_finish"] = date_finish
        json["name"] = name
        json["description"] = description
        return json
    }
}

