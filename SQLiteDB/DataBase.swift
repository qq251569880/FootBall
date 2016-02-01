//
//  CoreDataOperation.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit
import CoreData;

func saveChatMessage(msg:ChatMessage){
    CoreDataOperation.coreInstance.saveChatMessage(msg);
}
func getLastChatMessage(activeId:String) -> ChatMessage {
    return CoreDataOperation.coreInstance.getLastChatMessage(activeId);
}
func getChatMessage(activeId:String,limit:Int = 10,offSet:Int = 0) -> [ChatMessage] {
    return CoreDataOperation.coreInstance.getChatMessage(activeId,limit:limit,offSet:offSet);
}