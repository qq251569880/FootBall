//
//  AppDelegate.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit


class XmppDelegate: NSObject,XMPPStreamDelegate {

    var xmppStream:XMPPStream?
    var password:String = ""
    var isOpen:Bool = false;
    var isReged = true;
    var chatDelegate:ChatDelegate?
    var messageDelegate:MessageDelegate?;

    override init(){
    }

    func setupStream(){
    
        //初始化XMPPStream
        xmppStream = XMPPStream()
        xmppStream!.addDelegate(self,delegateQueue:dispatch_get_main_queue());
    
    }
    
    func goOnline(){
    
        //发送在线状态
        let presence:XMPPPresence = XMPPPresence()
        xmppStream!.sendElement(presence)
    
    }
    
    func goOffline(){
    
        //发送下线状态
        let presence:XMPPPresence = XMPPPresence(type:"unavailable");
        xmppStream!.sendElement(presence)
    
    }
    
    func connect(isreged:Bool) -> Bool{
    
        self.setupStream()
        isReged = isreged;
        //从本地取得用户名，密码和服务器地址
        
        let userId:String  = getLocalUserString("username")!
        let pass:String = getLocalUserString("xmpppassword")!
        let server:String = xmppServer
        
        if (!xmppStream!.isDisconnected()) {
            return true
        }
        
        if (userId == "" || pass == "") {
            return false;
        }
        
        //设置用户
        xmppStream!.myJID = XMPPJID.jidWithString(userId);
        //设置服务器
        xmppStream!.hostName = server;
        //密码
        password = pass;
        
        //连接服务器
        //var error:NSError? ;
        do{
            try xmppStream!.connectWithTimeout(XMPPStreamTimeoutNone)
        }catch{
            print("cannot connect \(server)")
            return false;
        }

        print("connect success!!!")
        return true;
    
    }
    
    func disconnect(){
    
        self.goOffline()
        xmppStream!.disconnect()
    
    }
    //XMPPStreamDelegate协议实现
    //连接服务器
    @objc func xmppStreamDidConnect(sender:XMPPStream ){
        print("xmppStreamDidConnect: \(xmppStream!.isConnected())")
        isOpen = true;
        //var error:NSError? ;
        //验证密码
        print(password)
        //self.goOnline()
        if(isReged){
            do{
                try self.xmppStream!.authenticateWithPassword(password);
            }catch {
                print("error");
            }
        }else{
            do{
                try self.xmppStream!.registerWithPassword(password);
            }catch {
                print("error");
            }
        }
    }
    //连接服务器
    @objc func xmppStreamDidDisConnect(sender:XMPPStream ,withError error:NSError){
        print("xmppStreamDidDisConnect:\(error)")
    }
    
    //验证通过
    @objc func xmppStreamDidAuthenticate(sender:XMPPStream ){
        print("xmppStreamDidAuthenticate")
        self.goOnline()
    }
    @objc func xmppStream(sender:XMPPStream , didNotAuthenticate error:DDXMLElement ){
        print(error)
    }
    //注册成功
    @objc func xmppStreamDidRegister(sender:XMPPStream ){
        print("xmppStreamDidRegister")
        //self.goOnline()
        isReged = true;
    }
    @objc func xmppStream(sender:XMPPStream , didNotRegister error:DDXMLElement ){
        print("didNotRegister:\(error)")
    }
    //收到消息@objc 
    @objc func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
    
       
        if message != nil {
            print(message)
            let cont:String = message!.elementForName("body").stringValue();
            let from:String = message!.attributeForName("from").stringValue();
            
            let msg:Message = Message(type:.Text,content:cont,sender:from,ctime:getCurrentTime())
            
            
            //消息委托(这个后面讲)
            messageDelegate?.newMessageReceived(msg);
        }
    
    }
    
    //收到好友状态
    @objc func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
    
        print(presence)
        
        //取得好友状态
        let presenceType:NSString = presence.type() //online/offline
        //当前用户
        let userId:NSString  = sender.myJID.user;
        //在线用户
        let presenceFromUser:NSString  = presence.from().user;
        
        if (!presenceFromUser.isEqualToString(userId as String)) {
            
            //在线状态
            let srv:String = "macshare.local"
            if (presenceType.isEqualToString("available")) {
                
                //用户列表委托
                chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(srv)")
                
            }else if (presenceType.isEqualToString("unavailable")) {
                //用户列表委托
                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(srv)")
            }
            
        }
    
    }
    func sendElement(mes:DDXMLElement){
        xmppStream!.sendElement(mes)
    }


}

