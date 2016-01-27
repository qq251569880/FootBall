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

    var messages = [Message]();
    @IBOutlet weak var MessageTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var chatWithUser = String();
    @IBOutlet weak var tView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let del:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        del.xmppDelegate!.messageDelegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func bubbleView(text:String,fromSelf:Bool,position:Int) -> UIView {
        let font:UIFont = UIFont.systemFontOfSize(14);
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        let rect:CGRect = text.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        let size:CGSize = rect.size;

        let retView = UIView(frame:CGRectZero);
        retView.backgroundColor = UIColor.clearColor();
        //背景图片
        let imgName = fromSelf == true ? "SenderAppNodeBkg_HL":"ReceiverTextNodeBkg";
        let imgPath = NSBundle.mainBundle().pathForResource(imgName,ofType:"png");
        let bubble:UIImage = UIImage(imageLiteral: imgPath!);
        //let a = floorf(Float(bubble.size.width)/Float(2.0))
        let bubbleImgView:UIImageView = UIImageView(image:bubble.stretchableImageWithLeftCapWidth(Int(floorf(Float(bubble.size.width)/Float(2.0))),topCapHeight:Int(floorf(Float(bubble.size.height)/Float(2.0)))));
        print("size:\(size.width),\(size.height)");

        //文本信息
        let bubbleText = UILabel(frame:CGRectMake(fromSelf == true ? 15.0 : 22.0,20.0,size.width + 10,size.height+10));
        bubbleText.backgroundColor = UIColor.clearColor();
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = .ByWordWrapping;
        bubbleText.text = text;
        let bubbleSize = bubbleText.frame.size;
        bubbleImgView.frame = CGRectMake(0,14,bubbleSize.width+30,bubbleSize.height + 20);

        if(fromSelf){
            retView.frame = CGRectMake(CGFloat(320-position-(Int(bubbleSize.width)+30)),0,bubbleSize.width+30,bubbleSize.height+30);
        }else{
            retView.frame = CGRectMake(CGFloat(position),0,bubbleSize.width+30,bubbleSize.height+30);
        }
        retView.addSubview(bubbleImgView);
        retView.addSubview(bubbleText);
        return retView;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    override func tableView(tableView:UITableView ,cellForRowAtIndexPath indexPath:NSIndexPath ) ->UITableViewCell{
        let identifier:String = "msgCell";
    
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier)
    
        if (cell == nil) {
            cell = UITableViewCell(style:.Default ,reuseIdentifier:identifier)
            cell!.selectionStyle = .None;
        }else{
            for cellView:UIView in cell!.subviews {
                cellView.removeFromSuperview();
            }
        }
        var msg:Message = messages[indexPath.row];
        return cell!;
    }
    //每一行的高度
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat{
        let msg:Message = messages[indexPath.row]; 
        let font:UIFont = UIFont.systemFontOfSize(14);
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        let rect:CGRect =  msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        let size:CGSize = rect.size;
        return size.height+44;
    }
    func newMessageReceived( msg:Message){
    
        messages.append(msg)
    
        self.tView.reloadData()
    }
    @IBAction func sendButton(sender: UIButton) {
        
        //本地输入框中的信息
        let message:String = self.MessageTextField.text!

        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(message)
            
            //生成XML消息文档
            let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            print("send to \(chatWithUser)")
            //由谁发送
            mes.addAttributeWithName("from" ,stringValue:getLocalUserString("userid"))
            //组合
            mes.addChild(body)
            
            //发送消息
            self.getXmppDelegate().sendElement(mes)
            
            self.MessageTextField.text = ""
            self.MessageTextField.resignFirstResponder()
            
            let msg:Message = Message(type:.Text,content:message,sender:"you",ctime:getCurrentTime())
            
            messages.append(msg)
            print("send msg:\(messages.count)(\(msg.content),\(msg.sender))")

            //重新刷新tableView
            self.tView.reloadData()
        }
    }
    func getXmppDelegate() -> XmppDelegate {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDel.xmppDelegate!;
    }
}

