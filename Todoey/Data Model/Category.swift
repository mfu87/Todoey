//
//  Category.swift
//  Todoey
//
//  Created by Marcus Fuchs on 07.08.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var name: String = ""
    
    //Relationship:
    let items = List<Item>()
    //List is from Realm and similar to arrays
}
