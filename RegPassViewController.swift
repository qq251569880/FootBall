//
//  RegPassViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit

class RegPassViewController: UIViewController,PduDelegate {

    var loginPdu:PtnLoginPDU?
    var changePassPdu:PtnNoBodyPDU?
    var forgetPassPdu:PtnNoBodyPDU?
    var vcodePdu:PtnNoBodyPDU?
    var userAction:RegPassAction = .Register;
    var tickDown:Int = 60;
    var timer:NSTimer?;

    @IBOutlet weak var regView: UIView!;
    @IBOutlet weak var changePassView: UIView!;
    @IBOutlet weak var resetPassView: UIView!;

    @IBOutlet weak var regUserName: UITextField!;
    @IBOutlet weak var regVerify: UITextField!;
    @IBOutlet weak var regPassword: UITextField!;

    @IBOutlet weak var oldPassword: UITextField!;
    @IBOutlet weak var newPassword1: UITextField!;
    @IBOutlet weak var newPassword2: UITextField!;
    
    @IBOutlet weak var resetUserName: UITextField!;
    @IBOutlet weak var resetVerify: UITextField!;
    @IBOutlet weak var resetNewPassword: UITextField!;
    
    @IBOutlet weak var regVcodeBtn: UIButton!
    @IBOutlet weak var changeVcodeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewLoc:CGRect = CGRectMake(20,30,300,200);
        regView.frame = viewLoc;
        changePassView.frame = viewLoc;       
        resetPassView.frame = viewLoc;       
        vcodePdu = PtnNoBodyPDU(url: "\(serverUrl)verify/send",actionid:"vcode");
        forgetPassPdu = PtnNoBodyPDU(url: "\(serverUrl)user/modifypass",actionid:"modifypass");
        changePassPdu = PtnNoBodyPDU(url: "\(serverUrl)user/forgotpass",actionid:"forgotpass");
        loginPdu = PtnLoginPDU(url: "\(serverUrl)user/reg");
        switch userAction {
        case .Register:
            changePassView.hidden = true;
            resetPassView.hidden = true;
            regView.hidden = false;
            break;
        case .ChangePassword:
            resetPassView.hidden = true;
            regView.hidden = true;
            changePassView.hidden = false;
            break;
        case .ForgotPassword:
            changePassView.hidden = true;
            regView.hidden = true;
            resetPassView.hidden = false;
            break;
        default:
            break;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentBtnClick(sender: AnyObject) {
        let segBtn = sender as! UISegmentedControl
		switch segBtn.selectedSegmentIndex {
        case 0:
            changePassView.hidden = true;
            resetPassView.hidden = true;
            regView.hidden = false;
            break;
        case 1:
            resetPassView.hidden = true;
            regView.hidden = true;
            changePassView.hidden = false;
            break;
        case 2:
            changePassView.hidden = true;
            regView.hidden = true;
            resetPassView.hidden = false;
            break
        default:
            break
		}
    }
    
    @IBAction func regSendVerify(sender: AnyObject) {
        if regUserName.text == nil || regUserName.text == "" {
            let alertController = UIAlertController(title: "提示", message: "请输入用户名", preferredStyle: .Alert);
            let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            vcodePdu!.setStringParameter("username",value:regUserName.text!);
            vcodePdu!.setStringParameter("action",value:"register");
            vcodePdu!.requestHttp();
        }
    }
    @IBAction func regBtnClick(sender: AnyObject) {
        let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
        if regUserName.text == nil || regUserName.text == "" {
            let alertController = UIAlertController(title: "提示", message: "请输入用户名", preferredStyle: .Alert);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: nil)
                return;
        }
        if regVerify.text == nil || regVerify.text == "" {
            let alertController = UIAlertController(title: "提示", message: "请输验证码", preferredStyle: .Alert);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: nil)
                return;
        }
        if regPassword.text == nil || regPassword.text == "" {
            let alertController = UIAlertController(title: "提示", message: "请输密码", preferredStyle: .Alert);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: nil)
                return;
        }
        loginPdu!.setStringParameter("username",value:regUserName.text!);
        loginPdu!.setStringParameter("password",value:regVerify.text!);
        loginPdu!.setStringParameter("vcode",value:regPassword.text!);
        loginPdu!.requestHttp();

    }
    @IBAction func modifyPassBtnClick(sender: AnyObject) {
    }
    
    @IBAction func resetPassSendVerify(sender: AnyObject) {
    }
    @IBAction func resetPassBtnClick(sender: AnyObject) {
    }
    
    func reloadTable(){
        print("viewController reload data!!!");
    }
    func returnSuccess(actionId: String) {
		switch actionId {
        case "vcode":
            if userAction == .Register {
                regVcodeBtn.enabled = false;
            }else{
                changeVcodeBtn.enabled = false;
            }
            tickDown = 60;
            timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:Selector("tickDownAction"),userInfo:nil,repeats:true);

            break;
        case "modifypass":
            let alertController = UIAlertController(title: "提示", message: "注册成功，返回个人信息", preferredStyle: .Alert);
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil);
            let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil);
            alertController.addAction(cancelAction);
            alertController.addAction(okAction);
            self.presentViewController(alertController, animated: true, completion: nil)
            break;
        case "forgotpass":
            break;
        case "login":
            break;
        default:
            break;
        }
        }
    func requestFailed(err: ErrInfo) {
        
    }
    func tickDownAction(){
        if userAction == .Register{
            regVcodeBtn.titleLabel?.text = "请\(tickDown)秒后重试";
            if tickDown == 0 {
                timer!.invalidate();
                regVcodeBtn.enabled = true;
            }
        }else{
            changeVcodeBtn.titleLabel?.text = "请\(tickDown)秒后重试";
            if tickDown == 0 {
                timer!.invalidate();
                changeVcodeBtn.enabled = true;
            }
        }
    }
    

}

