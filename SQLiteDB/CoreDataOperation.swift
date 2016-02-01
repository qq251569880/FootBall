//
//  CoreDataOperation.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit
import CoreData;

class CoreDataOperation {
    static let coreInstance = CoreDataOperation();
    var dataContext:NSManagedObjectContext;
    private init(){
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        dataContext = app.managedObjectContext;
    }
    func saveChatMessage(msg:ChatMessage){
        let chatMsg:ChatMessageData = NSEntityDescription.insertNewObjectForEntityForName("ChatMessageData",inManagedObjectContext: dataContext) as! ChatMessageData;
        if(msg.activeId != nil){
            chatMsg.activeId = msg.activeId;
        }
        if(msg.userId != nil){
            chatMsg.userId = msg.userId;
        }
        if(msg.messageType != nil){
            chatMsg.msgType = msg.messageType;
        }
        if(msg.content != nil){
            chatMsg.content = msg.content;
        }
        if(msg.xmppStatus != nil){
            chatMsg.xmppStatus = msg.xmppStatus;
        }
        if(msg.apiStatus != nil){
            chatMsg.apiStatus = msg.apiStatus;
        }
        if(msg.readStatus != nil){
            chatMsg.readStatus = msg.readStatus;
        }
        if(msg.messageId != nil){
            chatMsg.msgId = msg.messageId;
        }
        do {
            try dataContext.save()
            print("保存成功！")
        } catch {
             fatalError("不能保存：\(error)")
        }
    }
    func getLastChatMessage(activeId:String)-> ChatMessage{
        //声明数据的请求
        var retData:ChatMessage = ChatMessage();
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchLimit = 1 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
         
        //声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("ChatMessageData",
            inManagedObjectContext: dataContext)
        //设置数据请求的实体结构
        fetchRequest.entity = entity
         
        //设置查询条件
        let predicate = NSPredicate(format: "activeId= \(activeId) ", "")
        fetchRequest.predicate = predicate;
        let sortDescrpitor:NSSortDescriptor = NSSortDescriptor(key: "sendTime", ascending: true);
        fetchRequest.sortDescriptors = [sortDescrpitor];
        //查询操作
        do {
            let fetchedObjects:[AnyObject]? = try dataContext.executeFetchRequest(fetchRequest)
             
            //遍历查询的结果
            for info:ChatMessageData in fetchedObjects as! [ChatMessageData]{
                print("id=\(info.activeId)")
                print("userId=\(info.userId)")
                print("content=\(info.content)");
                retData = ChatMessage();
                retData.activeId = info.activeId;
                retData.userId = info.userId;
                retData.content = info.content;
                retData.messageType = info.msgType;
                break;
            }
        }
        catch {
            fatalError("查询失败：\(error)")
        }
        return retData;
    }
    func getChatMessage(activeId:String,limit:Int,offSet:Int)-> [ChatMessage]{
        //声明数据的请求
        var retData:[ChatMessage] = [];
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchLimit = 1 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
         
        //声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("ChatMessageData",
            inManagedObjectContext: dataContext)
        //设置数据请求的实体结构
        fetchRequest.entity = entity
         
        //设置查询条件
        let predicate = NSPredicate(format: "activeId= \(activeId) ", "")
        fetchRequest.predicate = predicate;
        let sortDescrpitor:NSSortDescriptor = NSSortDescriptor(key: "sendTime", ascending: true);
        fetchRequest.sortDescriptors = [sortDescrpitor];
        //查询操作
        do {
            let fetchedObjects:[AnyObject]? = try dataContext.executeFetchRequest(fetchRequest)
             
            //遍历查询的结果
            for info:ChatMessageData in fetchedObjects as! [ChatMessageData]{
                print("id=\(info.activeId)")
                print("userId=\(info.userId)")
                print("content=\(info.content)");
                var msg:ChatMessage = ChatMessage();
                msg.activeId = info.activeId;
                msg.userId = info.userId;
                msg.content = info.content;
                msg.messageType = info.msgType;
                retData.append(msg);
            }
        }
        catch {
            fatalError("查询失败：\(error)")
        }
        return retData;
    }}