//
//  SecondViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,PduDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!

    var userPdu:PtnUserInfoPDU?
    var loginPdu:PtnLoginPDU?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let accessToken = getLocalUserString("accesstoken");
        if accessToken != nil{
            self.performSegueWithIdentifier("main",sender:self);
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginBtnClick(sender: AnyObject) {
        loginPdu = PtnLoginPDU(url: "\(serverUrl)login");
        loginPdu!.delegate = self;
        loginPdu!.setStringParameter("username",value: nameField!.text!);
        loginPdu!.setStringParameter("password",value: passField!.text!);
        loginPdu!.requestHttp();
    }
    func requestFailed(err: ErrInfo) {
        
    }
    func returnSuccess(actionId:String){
        if(actionId == "login"){
            setLocalUserString("accesstoken",value: loginPdu!.loginBody!.accessToken!);
            setLocalUserString("userid",value: loginPdu!.loginBody!.userId!);
            print("xmpp password:\(loginPdu!.loginBody!.xmppPassword!)");

            userPdu = PtnUserInfoPDU(url: "\(serverUrl)user/query");
            userPdu!.setHeader("accesstoken",value: loginPdu!.loginBody!.accessToken!);
            userPdu!.delegate = self;
            userPdu!.requestHttp();
        }
    }
    //PduDelegate协议
    func reloadTable(){
		//activeList.reloadData();
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
                    setLocalUserString("provalue: vince",value: province);
                }
                if let city = userinfo.city {
                    setLocalUserString("city",value:city);
                }
                if let introduce = userinfo.introduce {
                    setLocalUserString("intrvalue: oduce",value:introduce);
                }
                break;
            }
        }
	}
}

