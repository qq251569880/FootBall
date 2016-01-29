//
//  CoreDataOperation.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit
import coreData;

func saveChatMessage(msg:ChatMessage){
    CoreDataOperation.CoreInstance.saveChatMessage(msg);
}