//
//  Dict2Model.swift
//  字典转模型01
//
//  Created by haochen on 15/3/4.
//  Copyright (c) 2015年 haochen. All rights reserved.
//

import Foundation

/**
    class_copyIvarList(<#cls: AnyClass!#>, <#outCount: UnsafeMutablePointer<UInt32>#>) 获取成员变量
     class_copyMethodList(<#cls: AnyClass!#>, <#outCount: UnsafeMutablePointer<UInt32>#>)  获取方法列表
class_copyPropertyList(<#cls: AnyClass!#>, <#outCount: UnsafeMutablePointer<UInt32>#>)   获取属性列表

还有一个是协议列表,一看就知道了.
*/

@objc protocol DictModelProtocol {
    
 //3.   //自定义映射列表 [属性名:自定义对象]
    //static 表示一个类方法,是在swift1.2之后修改的.原来是用class
    static func customClassMapping() -> [String:String]?
}

class dict2Model {
    
    func modelFullInfo(cls:AnyClass) ->[String: String]{
        var currentCls:AnyClass = cls
        
        var dictInfo = [String : String]()
        
        while let parent: AnyClass = currentCls.superclass() {
            dictInfo.merge(modelInfo(currentCls))
            
            currentCls = parent
        }
        return dictInfo
    }
 //5.   //获取给定类的信息
    func modelInfo(cls:AnyClass) ->[String :String]{
        
        //判断是否遵守了协议
        var mapping :[String:String]?
        if cls.respondsToSelector("customClassMapping"){
            print("实现了协议\n")
            //调用协议方法,获取自定义对象映射关系字典
            mapping = cls.customClassMapping()
        }
        //获得类属性
        var count :UInt32 = 0
        let ivars = class_copyIvarList(cls, &count)
        
        print("共有 \(count)个属性")
        //定义一个类属性的字典,[属性名称:自定义对象的名称/""]
        var dictInfo = [String:String]()
        
        for i in 0..<count{
            let ivar = ivars[Int(i)]
            
            let cname = ivar_getName(ivar)
            
            let name = String.fromCString(cname)
            
            
//            let ctype = ivar_getTypeEncoding(ivar)
//            let type = String.fromCString(ctype)
            let type = mapping?[name!] ?? ""
            
            //设置字典
            dictInfo[name!] = type
            
//            print("\(name!) --- \(type!)")
        }
        //这里是释放C语言产生的对象
        free(ivars)
        
        return dictInfo
        
    }
    
//2.    //加载属性列表
    func loadPeoperties(cls:AnyClass){
        var count :UInt32 = 0
        let peroperties = class_copyPropertyList(cls, &count)
        
        print("共有 \(count)个属性")
        
        for i in 0..<count{
            let property = peroperties[Int(i)]
            
            let cname = property_getName(property)
            
            let name = String.fromCString(cname)
            
            
            let ctype = property_getAttributes(property)
            let type = String.fromCString(ctype)
            
            print("\(name!) --- \(type!)")
        }
        //这里是释放C语言产生的对象
        free(peroperties)
    }
    
 //1.   //加载成员变量
    func loadIvars(cls:AnyClass){
        
        //获得类属性
        //swift也是ARC机制,只会自动swift部分的代码,所以出现C语言代码的时候,有copy/create/retain/new字样的函数的时候,要释放对象 (free/release)
        
        var count :UInt32 = 0
        let ivars = class_copyIvarList(cls, &count)
        
       
        
        for i in 0..<count{
            let ivar = ivars[Int(i)]
            
            let cname = ivar_getName(ivar)
            
            let name = String.fromCString(cname)
            
            
            let ctype = ivar_getTypeEncoding(ivar)
            let type = String.fromCString(ctype)
            
        }
        //这里是释放C语言产生的对象
        free(ivars)
        
    }
    
}

extension Dictionary{
    ///将给定的字典(可变的)合并到当前字典
    /// mutating 表示函数操作的字典是可变类型
    /// 泛型(随便一个类型),封装一些函数或者方法,更加具有弹性
 //4.5   /// 任何两个 [key:value]类型匹配的字典,都可以进行合并操作.
    
    mutating func merge<K,V>(dict:[K:V]){
        for (k,v) in dict{
            //在字典方法中,如果用updateValue,需要明确指定类型
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}