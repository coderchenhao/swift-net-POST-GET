//
//  ViewController.swift
//  字典转模型01
//
//  Created by haochen on 15/3/3.
//  Copyright (c) 2015年 haochen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(loadJSON())
        
        var d = dict2Model()
        d.modelFullInfo(SubModel.self)
        print("模型字典 -- \(d.modelFullInfo(SubModel.self))")
    }

    
    func loadJSON()->NSDictionary{
        
        let path = NSBundle.mainBundle().pathForResource("Model01.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        
        return NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary

    }


}

