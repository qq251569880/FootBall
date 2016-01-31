//
//  SecondViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,PduDelegate,UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!

    var userPdu:PtnUserInfoPDU?
    var loginPdu:PtnLoginPDU?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        }

    }

    @IBAction func registBtnClick(sender: AnyObject) {
        self.performSegueWithIdentifier("regpass",sender:self);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getXmppDelegate() -> XmppDelegate {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDel.xmppDelegate!;
    }

    @IBAction func loginBtnClick(sender: AnyObject) {
        let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
       if(nameField!.text == nil || nameField!.text == ""){
            let alertController = UIAlertController(title: "提示", message: "请输入用户名", preferredStyle: .Alert);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: {self.nameField!.becomeFirstResponder()})
            return;
        }
        if(passField!.text == nil || passField!.text == ""){
            let alertController = UIAlertController(title: "提示", message: "请输入密码", preferredStyle: .Alert);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: {self.passField!.becomeFirstResponder()})
            return;
        }
        loginPdu = PtnLoginPDU(url: "\(serverUrl)login");
        loginPdu!.delegate = self;
        loginPdu!.setStringParameter("username",value: nameField!.text!);
        loginPdu!.setStringParameter("password",value: passField!.text!);
        setLocalUserString("username",value: nameField!.text!);
        loginPdu!.requestHttp();
    }
    func requestFailed(err: ErrInfo) {
        print(err.print());
    }
    func returnSuccess(actionId:String){
        if(actionId == "login"){
            setLocalUserString("accesstoken",value: loginPdu!.loginBody!.accessToken!);
            setLocalUserString("userid",value: loginPdu!.loginBody!.userId!);
            print("xmpp password:\(loginPdu!.loginBody!.xmppPassword!)");
            setLocalUserString("xmpppassword",value: loginPdu!.loginBody!.xmppPassword!);
            if (loginPdu!.loginBody!.xmppStatus == "reged"){
                let xmppRet = self.getXmppDelegate().connect(true);
                if (xmppRet == false){
                    let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
                    let alertController = UIAlertController(title: "提示", message: "聊天服务登录失败", preferredStyle: .Alert);
                    alertController.addAction(okAction);
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else if (loginPdu!.loginBody!.xmppStatus == "unreg"){
                
            }else{
                let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
                let alertController = UIAlertController(title: "提示", message: "需要修改xmpp密码", preferredStyle: .Alert);
                alertController.addAction(okAction);
                self.presentViewController(alertController, animated: true, completion: nil)

            }
            userPdu = PtnUserInfoPDU(url: "\(serverUrl)user/query");
            userPdu!.setHeader("accesstoken",value: loginPdu!.loginBody!.accessToken!);
            userPdu!.delegate = self;
            userPdu!.requestHttp();
        }
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
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        if (textField == self.nameField) {
            textField.resignFirstResponder();
        }
        if (textField == self.passField) {
            textField.resignFirstResponder();
        }
        return true
    }

}

