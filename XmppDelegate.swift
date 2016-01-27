//
//  AppDelegate.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit


class XmppDelegate: XMPPStreamDelegate {

    var xmppStream:XMPPStream?
    var password:String = ""
    var isOpen:Bool = false
    var chatDelegate:ChatDelegate?
    var messageDelegate:MessageDelegate?;

    func init(){
    }

    func setupStream(){
    
        //初始化XMPPStream
        xmppStream = XMPPStream()
        xmppStream!.addDelegate(self,delegateQueue:dispatch_get_main_queue());
    
    }
    
    func goOnline(){
    
        //发送在线状态
        var presence:XMPPPresence = XMPPPresence()
        xmppStream!.sendElement(presence)
    
    }
    
    func goOffline(){
    
        //发送下线状态
        var presence:XMPPPresence = XMPPPresence(type:"unavailable");
        xmppStream!.sendElement(presence)
    
    }
    
    func connect() -> Bool{
    
        self.setupStream()
    
        //从本地取得用户名，密码和服务器地址
        var defaults:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        
        var userId:String  = defaults.stringForKey(USERID)
        var pass:String = defaults.stringForKey(PASS)
        var server:String = defaults.stringForKey(SERVER)
        
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
        var error:NSError? ;
        if (!xmppStream!.connectWithTimeout(XMPPStreamTimeoutNone,error: &error)) {
            println("cannot connect \(server)")
            return false;
        }
        println("connect success!!!")
        return true;
    
    }
    
    func disconnect(){
    
        self.goOffline()
        xmppStream!.disconnect()
    
    }
    //XMPPStreamDelegate协议实现
    //连接服务器
    func xmppStreamDidConnect(sender:XMPPStream ){
        println("xmppStreamDidConnect \(xmppStream!.isConnected())")
        isOpen = true;
        var error:NSError? ;
        //验证密码
        println(password)
        self.goOnline()
        xmppStream!.authenticateWithPassword(password ,error:&error);
        if error != nil {
            println(error!)
        }
    }
    
    //验证通过
    func xmppStreamDidAuthenticate(sender:XMPPStream ){
        println("xmppStreamDidAuthenticate")
        self.goOnline()
    }
    func xmppStream(sender:XMPPStream , didNotAuthenticate error:DDXMLElement ){
        println(error)
    }
    //收到消息
    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
    
       
        if message != nil {
            println(message)
            var cont:String = message!.elementForName("body").stringValue();
            var from:String = message!.attributeForName("from").stringValue();
            
            var msg:Message = Message(content:cont,sender:from,ctime:getCurrentTime())
            
            
            //消息委托(这个后面讲)
            messageDelegate?.newMessageReceived(msg);
        }
    
    }
    
    //收到好友状态
    func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
    
        println(presence)
        
        //取得好友状态
        var presenceType:NSString = presence.type() //online/offline
        //当前用户
        var userId:NSString  = sender.myJID.user;
        //在线用户
        var presenceFromUser:NSString  = presence.from().user;
        
        if (!presenceFromUser.isEqualToString(userId)) {
            
            //在线状态
            var srv:String = "macshare.local"
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

