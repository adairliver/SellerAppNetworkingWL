//
//  Cat670055.swift
//  WorklightTest
//
//  Created by Luis Cuevas on 20/06/17.
//  Copyright © 2017 Deloitte. All rights reserved.
//

import Foundation
import ObjectMapper

class Cat670055: Mappable{
    var NAME: String?
    var CHILDPRODUCTS_COUNT: String?
    var L2CategoryInfo: L2CategoryInfo?
    var RootIndexValue: Float?
    var ID: String?
    var CHILDCATEGORY_COUNT: Float?
    
    required init?(map: Map){
    }
    func mapping(map: Map){
        NAME <- map["NAME"]
        CHILDPRODUCTS_COUNT <- map["CHILDPRODUCTS_COUNT"]
        L2CategoryInfo <- map["L2CategoryInfo"]
        RootIndexValue <- map["RootIndexValue"]
        ID <- map["ID"]
        CHILDCATEGORY_COUNT <- map["CHILDCATEGORY_COUNT"]
    }
}