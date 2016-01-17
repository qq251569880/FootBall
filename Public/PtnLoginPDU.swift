//
//  PtnCreateResultPDU.swift
//  Partner
//
//  Created by 张宏台 on 15/12/19.
//  Copyright © 2015年 张宏台. All rights reserved.
//

import Foundation
class PtnLoginPDU :PtnPDU
{
    var loginBody:PtnLoginBody?
    override init(){
        super.init();
    }
    init(url:String){
        super.init();
        requestUrl = url;
    }
    
    override func decodeReturnBody(){
        loginBody = PtnLoginBody(responseJson!.body!);
        delegate!.returnSuccess("login");
    }
}