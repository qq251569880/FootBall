//
//  PtnCreateResultPDU.swift
//  Partner
//
//  Created by 张宏台 on 15/12/19.
//  Copyright © 2015年 张宏台. All rights reserved.
//

import Foundation
class PtnCreateResultPDU :PtnPDU
{
    var createBody:PtnCreateBody?
    var objectKey:String?
    override init(){
        super.init();
    }
    init(url:String,id:String,actionid:String=""){
        super.init();
        requestUrl = url;
        objectKey = id;
        actionId = actionid;
    }
    
    override func decodeReturnBody(){
        createBody = PtnCreateBody(decoder:responseJson!.body!,id:objectKey!);
        delegate!.returnSuccess(actionId!);
    }
}