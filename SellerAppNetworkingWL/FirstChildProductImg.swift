//
//  FirstChildProductImg.swift
//  WorklightTest
//
//  Created by Luis Cuevas on 20/06/17.
//  Copyright © 2017 Deloitte. All rights reserved.
//

import Foundation
import ObjectMapper

class FirstChildProductImg: Mappable{
    var largeImage: String?
    var smallImage: String?
    var thumbnailImage: String?
    
    required init?(map: Map){
    }
    func mapping(map: Map){
        largeImage <- map["largeImage"]
        smallImage <- map["smallImage"]
        thumbnailImage <- map["thumbnailImage"]
    }
}
