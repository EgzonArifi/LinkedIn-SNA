//
//  LoadFile.swift
//  LinkedIn-SNA
//
//  Created by Egzon Arifi on 12/23/17.
//  Copyright © 2017 Overjump. All rights reserved.
//

import Foundation

class LoadFile {
    
    static func loadUser(fromFile file:String) -> [User] {
        
        do {
            
            if let file = Bundle.main.url(forResource: file, withExtension: "json") {
                
                var users = [User]()
                
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    
                    for item in object {
                        let user = User.init(fromDictionary: item as! NSDictionary)
                        users.append(user)
                    }
                    
                    return users
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
