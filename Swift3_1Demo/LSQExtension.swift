//
//  LSQExtension.swift
//  Swift3_1Demo
//
//  Created by sqluo on 2017/4/1.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

extension UIView {
    //上左点
    public var topLeftPoint: CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
    }
    //上右点
    public var topRightPoint: CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y)
    }
    //下左点
    public var bottomLeftPoint: CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height)
    }
    //下右点
    public var bottomRihgtPoint: CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + self.frame.height)
    }
}

extension String {
    ///CommonCrypto 还没有兼容 Swift，所以为了使用它，我们需要通过头文件导入 Objective-C 形式的 CommonCrypto。
    ///#import <CommonCrypto/CommonDigest.h>
    //TODO:小写32位md5
    public var md5_32Bit: String {
        
        let cStr = self.cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cStr!, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)),buffer)
        let md5str = NSMutableString()
        
        for i in 0..<CC_MD5_DIGEST_LENGTH
        {
            md5str.appendFormat("%02x", buffer[Int(i)])
        }
        buffer.deinitialize()
        return md5str as String
    }
    
    //TODO:去除首尾空格和换行
    public var removeSpaceAndEnter: String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.characters.isEmpty})
        return components.joined(separator: " ")
    }
    //TODO:去除字符串首尾空格
    var removeSpace:String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    //时间格式转换成时间戳
    func conversionToTimeStamp(with formats: [TimeStampType]) -> Double?{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        var timeStamp: Double?
        for type in formats {
            formatter.dateFormat = type.rawValue
            if let date = formatter.date(from: self){
                timeStamp = date.timeIntervalSince1970
                break
            }
        }
        return timeStamp
    }
    //String -> 得到对应的 UIViewController？
    public var viewController: UIViewController? {
        
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        let cls: AnyClass? = NSClassFromString((clsName as! String) + "." + self)
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return nil
        }
        let viewCtr = clsType.init()
        return viewCtr
    }
    
    
    
}

extension NSObject {
    
    //MARK:基于NSObject的类，根据字典给属性赋值
    //可自定义类，model
    /**
     - parameter dict:     需要设置的字典
     */
    public func setMembers(of dict: [String:Any]){
        
        var tmpDict = dict          //返回的字典
        var members = [String]()    //存放类所有成员
        var count: UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count) //获取有多少个成员
        for i in 0..<Int(count) {
            let ivar = ivars![i]
            let name = ivar_getName(ivar)
            let strName = String(cString: name!)
            members.append(strName)
        }
        free(ivars)
        //排查是否含有该成员
        for (key,_) in tmpDict {
            if !members.contains(key) {
                print("**不包含该key**:\(key)")
                tmpDict.removeValue(forKey: key)
            }
        }
        //给所有成员赋值
        self.setValuesForKeys(tmpDict)
    }
    
   
}


extension UIColor {
    
    //16进制颜色
    class func hex(string: String) -> UIColor? {
        
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.characters.count < 6
        {
            return nil
        }
        if cString.hasPrefix("0X")
        {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        if cString .hasPrefix("#")
        {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        if cString.characters.count != 6
        {
            return nil
        }
        
        
        let rrange = Range(cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2))
        let rString = cString.substring(with: rrange)
        
        
        let grange = Range(cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4))
        let gString = cString .substring(with: grange)
        
        
        let brange = Range(cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6))
        let bString = cString .substring(with: brange)
        
        
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0,
                       green: CGFloat(g) / 255.0,
                       blue: CGFloat(b) / 255.0,
                       alpha: 1)
    }
    
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    
    //TODO:颜色转图片
    public var conversionImage: UIImage?{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}


enum TimeStampType: String {
    case hms    = "HH:mm:ss"    //时-分-秒
    case hm     = "HH:mm"       //时-分
    case ms     = "mm:ss"       //分-秒
    
    case md     = "MM-dd"       //月-日
    case yMd    = "yyyy-MM-dd"  //年-月-日
    case yMdHm  = "yyyy-MM-dd HH:mm" //年-月-日 时-分
    
    case yMdHms = "yyyy-MM-dd HH:mm:ss" //年-月-日 时:分:秒
    
    //
    static func getCaseRawValueArray() -> [TimeStampType] {
        
        let hms     = TimeStampType.hms
        let hm      = TimeStampType.hm
        let ms      = TimeStampType.ms
        
        let md      = TimeStampType.md
        let yMd     = TimeStampType.yMd
        let yMdHm   = TimeStampType.yMdHm
        
        let yMdHms  = TimeStampType.yMdHms
       
        let caseRawValue = [hms,hm,ms,md,yMd,yMdHm,yMdHms]
        return caseRawValue
    }
    
}

extension Double {
    //TODO:时间戳转时间
    func conversionToString(with format: TimeStampType) -> String{
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format.rawValue
        let formStr = formatter.string(from: date)
        return formStr
    }
    //TODO:时间戳格式化为 天-小时-分-秒
    public var conversionMM_dd__HH_mm_ss: String {
        let second  = 1             //秒
        let min     = 60 * second   //分
        let hour    = 60 * min      //时
        let day     = 24 * hour     //天
        
        let tmp = Int(self)
      
        switch tmp {
        case 0..<min:
            return "00-00:00:" + String(format: "%02d", tmp)
        case min..<hour:
            return "00-00:" + String(format: "%02d", tmp / min) + ":" + String(format: "%02d", tmp % min)
        case hour..<day:
            let h = String(format: "%02d", tmp / hour)
            let m = String(format: "%02d", tmp % hour / min)
            let s = String(format: "%02d", tmp % hour % min)
            return "00-\(h):\(m):\(s)"
        default:
            let d = String(format: "%02d", tmp / day)
            let h = String(format: "%02d", tmp % day / hour)
            let m = String(format: "%02d", tmp % day % hour / min)
            let s = String(format: "%02d", tmp % day % hour % min)
            return "\(d)-\(h):\(m):\(s)"
        }
    }
    
    
    
}


extension UIImage{
    
    class func image(with color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}



