//
//  ChatMessage+CoreDataProperties.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/27.
//  Copyright © 2016年 张宏台. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ChatMessageData {

    @NSManaged var activeId: String?
    @NSManaged var userId: String?
    @NSManaged var msgType: String?
    @NSManaged var content: String?
    @NSManaged var fileData: NSData?
    @NSManaged var sendTime: NSDate?
    @NSManaged var xmppStatus: NSNumber?
    @NSManaged var apiStatus: NSNumber?
    @NSManaged var readStatus: NSNumber?
    @NSManaged var msgId: String?

}
