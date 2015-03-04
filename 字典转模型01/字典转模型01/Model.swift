//
//  Model.swift
//  字典转模型01
//
//  Created by haochen on 15/3/3.
//  Copyright (c) 2015年 haochen. All rights reserved.
//

import UIKit

class Model: NSObject ,DictModelProtocol{
    
    var str1 : String?
    var str2 : String?
    var b : Bool = true
    var i : Int = 0
    var f : Float = 0
    var d : Double = 0
    var num : NSNumber?
    var info : Info?
    var other : [Info]?
    var others : NSArray?
//4.
     static func customClassMapping() -> [String : String]? {
        return ["info":"Info","other":"Info","others":"Info"]
    }
}

class SubModel: Model {
    var boy:String?
}

class Info : NSObject{
    var name : String?
}
