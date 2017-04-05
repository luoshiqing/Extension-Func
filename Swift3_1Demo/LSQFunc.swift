//
//  LSQFunc.swift
//  Swift3_1Demo
//
//  Created by sqluo on 2017/4/1.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

///MARK:属性
let WIDTH = UIScreen.main.bounds.size.width     //屏幕宽度
let HEIGHT = UIScreen.main.bounds.size.height   //屏幕高度

let SCALE320 = WIDTH / 320.0    //屏幕宽度为320的宽缩放倍数
let SCALE375 = WIDTH / 375.0    //屏幕宽度为375的宽缩放倍数



//MARK:获得随机数
public func RandomString(with range: CountableClosedRange<Int>) -> String{
    
    let count = UInt32(range.upperBound - range.lowerBound + 1)
    
    let value2 = String(Int(arc4random_uniform(count)) + range.lowerBound)
    
    var characters = ""
    for character in value2.characters {
        let str = String(character)
        //加65才能转化
        let n: UInt32 = UInt32(str)! + 65
        let cha = Character(UnicodeScalar(n)!)
        characters += "\(cha)"
    }
    
    //随机一个字母
    let oneR = 65 + arc4random() % 26
    let oneC = String(Character(UnicodeScalar(oneR)!))
    
    let endValue = oneC + value2 + characters
    
    return endValue
}

//MARK:随机一个数
public func Random(in range: CountableClosedRange<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound + 1)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}

//MARK:延迟异步执行方法
public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

//MARK:字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

//MARK:获取手机型号
public func getDeviceMode() -> String {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        
        guard let value = element.value as? Int8 , value != 0
            else
        {
            return identifier
        }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    case "iPod5,1":                                 return "iPod Touch 5"
    case "iPod7,1":                                 return "iPod Touch 6"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPhone9,1","iPhone9,3":                   return "iPhone 7"
    case "iPhone9,2","iPhone9,4":                   return "iPhone 7 Plus"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
    case "iPad6,7", "iPad6,8":                      return "iPad Pro"
    case "AppleTV5,3":                              return "Apple TV"
    case "i386", "x86_64":                          return "Simulator"
    default:                                        return identifier
    }
  
}
//MARK:获取app版本号
public func getAppVersion() -> String?{
    let infoDictionary = Bundle.main.infoDictionary
    let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as? String
    
    return currentAppVersion
}
//MARK:获取系统版本
public func getSystemVersion() -> String {
    let result = UIDevice.current.systemVersion
    return result
}
//MARK:打印信息
public func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
//TODO:-获取文本的高度
///*text 文本
///*with 宽度
///*font 字体
public func getTextHeight(with text: String, width: CGFloat, font: UIFont) -> CGFloat {
    let string = text as NSString
    let origin = NSStringDrawingOptions.usesLineFragmentOrigin
    let lead = NSStringDrawingOptions.usesFontLeading
    let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin,lead], attributes: [NSFontAttributeName:font], context: nil)
    return rect.height
}
//TODO:-获取文本的宽度
public func getTextWidth(with text: String, height: CGFloat, font: UIFont) -> CGFloat {
    let string = text as NSString
    let origin = NSStringDrawingOptions.usesLineFragmentOrigin
    let lead = NSStringDrawingOptions.usesFontLeading
    let rect = string.boundingRect(with: CGSize(width: 0, height: height), options: [origin,lead], attributes: [NSFontAttributeName:font], context: nil)
    return rect.width
}












