//
//  PtnNoBodyPDU.swift
//  Partner
//
//  Created by 张宏台 on 15/12/19.
//  Copyright © 2015年 张宏台. All rights reserved.
//

import Foundation
class PtnNoBodyPDU :PtnPDU
{
    override init(){
        super.init();
    }
    init(url:String,actionid:String=""){
        super.init();
        requestUrl = url;
        actionId = actionid;
    }
    override func decodeNoBodySucc(){
        delegate!.returnSuccess(actionId!);
    }
}
