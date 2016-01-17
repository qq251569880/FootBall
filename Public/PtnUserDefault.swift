import Foundation
func getLocalUserString(key:String?) -> String? {
    if let k = key {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        return userDefaults.stringForKey(k);
    }
    return nil;
}
func setLocalUserString(key:String?,value:String?) -> Bool {
    if let k = key{
        if let v = value {
            let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            userDefaults.setObject(v as AnyObject,forKey:k);
        }else{
            return false;
        }
    }else{
        return false;
    }
    return true;
}
func getLocalUserFloat(key:String?) -> Float? {
    if let k = key {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        return userDefaults.floatForKey(k);
    }
    return nil;
}
func setLocalUserFloat(key:String?,value:Float?) -> Bool {
    if let k = key{
        if let v = value {
            let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            userDefaults.setFloat(v,forKey:k);
        }else{
            return false;
        }
    }else{
        return false;
    }
    return true
}
func clearUserString(key:String?){
    if let k = key {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        userDefaults.removeObjectForKey(k);
        userDefaults.synchronize();
    }
    
}
/*
userid              用户id
accesstoken         登录token
username            用户名，手机或者邮箱的一种，以用户输入为准
mobile              用户手机
email               用户邮箱
nickname            用户昵称
birth               用户出生年月
sex                 用户性别
avatar              用户头像
country             用户国家
province            用户省份
city                用户城市
address             用户详细地址
introduce           用户简介
currentcountry      用户当前所处位置的国家
currentprovince     用户当前所处位置的省份
currentcity         用户当前所处位置的城市
currentlat          用户当前所处位置的纬度
currentlon          用户当前所处位置的经度
*/