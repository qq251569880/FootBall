//
//  ChatViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit
enum MessageType{
    case Text
    case Picture
    case Voice
    case Video
}
struct Message{
    var type:MessageType
    var content:String
    var sender:String
    var ctime:String
}
class ChatViewController: UITableViewController,MessageDelegate {

    var messages = Message[]();
    @IBOutlet var MessageTextField : UITextField;
    @IBOutlet var sendBtn : UIButton;
    var chatWithUser = String();
    @IBOutlet var tView : UITableView;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var del:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
        del.xmppDelegate!.messageDelegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func bubbleView(text:NSString,fromSelf:Bool,position:Int) -> UIView {
        let font:UIFont = UIFont.systemFontOfSize(14);
        var textSize = CGSize(width: 260.0 ,height: 10000.0)
        var rect:CGRect = text.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        var size:CGSize = rect.size();

        var retView = UIView(frame:CGRectZero);
        retView.backGroundColor = UIColor.clearColor();
        //背景图片
        var imgPath = NSBundle.mainBundle().pathForResource(fromSelf?"SenderAppNodeBkg_HL":"ReceiverTextNodeBkg",ofType:"png");
        var bubble:UIImage = UIImage(imgPath);

        var bubbleImgView:UIImageView = UIImageView(image:bubble.stretchableImageWithLeftCapWidth(floorf(bubble.size.width/2),topCapHeight:floorf(bubble.size.height/2)));
        print("size:\(size.width),\(size.height)");

        //文本信息
        var bubbleText = UILabel(frame:CGRectMake(fromSelf?15.0:22.0,20.0,size.width + 10,size.height+10));
        bubbleText.backGroundColor = UIColor.clearColor();
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = .ByWordWrapping;
        bubbleText.text = text;
        bubbleSize = bubbleText.frame.size;
        bubbleImgView.frame = CGRectMake(0,14,bubbleSize.width+30,bubbleSize.height + 20);

        if(fromSelf){
            retView.frame = CGRectMake(320-position-(bubbleSize.width+30),0,bubbleSize.width+30,bubbleSize.height+30);
        }else{
            retView.frame = CGRectMake(position,0,bubbleSize.width+30,bubbleSize.height+30);
        }
        retView.addSubview(bubbleImgView);
        retView.addSubview(bubbleText);
        return retView;
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    func tableView(tableView:UITableView! ,cellForRowAtIndexPath indexPath:NSIndexPath ) ->UITableViewCell{
        var identifier:String = "msgCell";
    
        var cell:UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) 
    
        if (cell == nil) {
            cell = UITableViewCell(newStyle:.Default ,newReuseIdentifier:identifier)
            cell.selectionStyle = .None;
        }else{
            for cellView:UIView in cell.subviews() {
                cellView.removeFromSuperview();
            }
        }
        var msg:Message = messages[indexPath.row];
    }
    //每一行的高度
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat{
        var msg:Message = messages[indexPath.row]; 
        let font:UIFont = UIFont.systemFontOfSize(14);
        var rect:CGRect =  msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        var size:CGSize = rect.size();
        eturn size.height+44;  
    }
    func newMessageReceived(var msg:Message){
    
        messages.append(msg)
    
        self.tView.reloadData()
    }
    @IBAction func sendButton(sender : UIButton) {
        
        //本地输入框中的信息
        var message:String = self.MessageTextField.text

        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            var body:DDXMLElement = DDXMLElement.elementWithName("body") as DDXMLElement
            body.setStringValue(message)
            
            //生成XML消息文档
            var mes:DDXMLElement = DDXMLElement.elementWithName("message") as DDXMLElement
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            println("send to \(chatWithUser)")
            //由谁发送
            mes.addAttributeWithName("from" ,stringValue:NSUserDefaults.standardUserDefaults().stringForKey(USERID) as NSString)
            //组合
            mes.addChild(body)
            
            //发送消息
            self.appDelegate().sendElement(mes)
            
            self.MessageTextField.text = ""
            self.MessageTextField.resignFirstResponder()
            
            var msg:Message = Message(content:message,sender:"you",ctime:getCurrentTime())
            
            messages.append(msg)
            println("send msg:\(messages.count)(\(msg.content),\(msg.sender))")

            //重新刷新tableView
            self.tView.reloadData()
    }
}

