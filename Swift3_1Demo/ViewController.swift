//
//  ViewController.swift
//  Swift3_1Demo
//
//  Created by sqluo on 2017/4/1.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        let time: Double = 1491022687.0
        
        let strTime = time.conversionToString(with: TimeStampType.ms)
        print(strTime)
        
        let array = TimeStampType.getCaseRawValueArray()
        let doubleTime = strTime.conversionToTimeStamp(with: array)

        
        guard let dt = doubleTime else {
            return
        }
        
        print(dt)
        
        let str2 = dt.conversionToString(with: .yMdHms)
        
        print(str2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

