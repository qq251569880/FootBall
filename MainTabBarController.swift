//
//  SetViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController ,PduDelegate{

    var userPdu:PtnUserInfoPDU?;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.viewControllers = [FootballViewController(),HistoryViewController(),SelfInfoViewController()];
        //self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        let accessToken = getLocalUserString("accesstoken");
        if accessToken != nil{
            let xmppRet = self.getXmppDelegate().connect(true);
            if (xmppRet == false){
                let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
                let alertController = UIAlertController(title: "提示", message: "聊天服务登录失败", preferredStyle: .Alert);
                alertController.addAction(okAction);
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            userPdu = PtnUserInfoPDU(url: "\(serverUrl)user/query");
            userPdu!.setHeader("accesstoken",value: accessToken!);
            userPdu!.delegate = self;
            userPdu!.requestHttp();
        }else{
            self.performSegueWithIdentifier("login",sender:self);
        }
        
    }
    func getXmppDelegate() -> XmppDelegate {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDel.xmppDelegate!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //PduDelegate协议
    func reloadTable(){
        //activeList.reloadData();
        print("getting user info");
        let userid = getLocalUserString("userid");
        for userinfo in userPdu!.userInfo! {
            if(userinfo.userId == userid){
                if let nickname = userinfo.nickName {
                    setLocalUserString("nickname",value: nickname);
                }
                if let avatar = userinfo.avatar {
                    setLocalUserString("avatar",value: avatar);
                }
                if let country = userinfo.country {
                    setLocalUserString("country",value: country);
                }
                if let province = userinfo.province {
                    setLocalUserString("province",value: province);
                }
                if let city = userinfo.city {
                    setLocalUserString("city",value:city);
                }
                if let introduce = userinfo.introduce {
                    setLocalUserString("introduce",value:introduce);
                }
                break;
            }
        }
    }
    func requestFailed(err: ErrInfo) {
        print(err.print());
    }
    func returnSuccess(actionId:String){
    }
}

