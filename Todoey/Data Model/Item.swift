//
//  Item.swift
//  Todoey
//
//  Created by Marcus Fuchs on 07.08.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Relationship: Links item to parentCategogy
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //Typ: Category is the class, not the type. To make it the type add ".self"  / Property: "name" of forward relationship
}
