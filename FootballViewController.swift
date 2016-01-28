//
//  FootballViewController.swift
//  FootBall
//
//  Created by 张宏台 on 16/1/16.
//  Copyright © 2016年 张宏台. All rights reserved.
//

import UIKit

class FootballViewController: UITableViewController,PduDelegate {

    @IBOutlet var sportsList: UITableView!
    var activePdu:PtnActiveInfoQueryPDU?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activePdu = PtnActiveInfoQueryPDU(url: "\(serverUrl)active/query");
        activePdu!.delegate = self;
        activePdu!.setSportListViewFields();
        activePdu!.requestHttp();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getTextLabel(left:CGFloat,top:CGFloat,direct:Bool,fontSize:Int,text:String) -> UILabel {
        //标题
        let font:UIFont = UIFont.systemFontOfSize(CGFloat(fontSize));
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        let rect:CGRect = text.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        let size:CGSize = rect.size;
        
        let bubbleText = UILabel(frame:CGRectMake(direct ? left:260-left,top,size.width+5,size.height+5));
        bubbleText.backgroundColor = UIColor.clearColor();
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = .ByWordWrapping;
        bubbleText.text = text;
        return bubbleText;
    }
    func activeView(active:ActiveInfo,row:Int) -> UIView{
        let retView = UIView(frame:CGRectZero);
        retView.backgroundColor = UIColor.clearColor();
        //背景图片
        let imgName = (row % 2) == 0 ? "itemgreen":"itemblue";
        let imgPath = NSBundle.mainBundle().pathForResource(imgName,ofType:"png");
        let bimg:UIImage = UIImage(imageLiteral: imgPath!);
        //let a = floorf(Float(bubble.size.width)/Float(2.0))
        let bimgView:UIImageView = UIImageView(image:bimg.stretchableImageWithLeftCapWidth(260,topCapHeight:120));
        bimgView.frame = CGRectMake(0,5,260,120);
        bimgView.layer.cornerRadius = 12;
        bimgView.layer.masksToBounds = true;
    
        let titleLabel = getTextLabel(100,top:5,direct:true,fontSize:16,text:active.title!);
        let timeLabel = getTextLabel(100,top:25,direct:true,fontSize:14,text:"时间:\(active.startTime!.subStringFrom(5).subStringTo(11))");
        let placeLabel = getTextLabel(100,top:40,direct:true,fontSize:14,text:"地点：\(active.address!)");
        let contentLabel = getTextLabel(100,top:55,direct:true,fontSize:14,text:active.introduce!);
        let creatorLabel = getTextLabel(10,top:90,direct:true,fontSize:14,text:active.creatorName!);
        var partiStr = "";
        if let num = active.inmember {
            if(num > 0){
                partiStr = "已经有\(active.inmember)人参与";
            }else{
                partiStr = "暂无人参与";
            }
        }else{
            partiStr = "暂无人参与";
        } 
        let partiLabel = getTextLabel(10,top:6,direct:false,fontSize:12,text:partiStr);
        
        var creatorImg:UIImage? = nil;
        let imageUrl = active.creatorAvatar;
        if(imageUrl != nil){
            if let aimage = UIImage(data:NSData(contentsOfURL:NSURL(string:imageUrl!)!)!) {
                creatorImg = aimage;
            }
        }
        if(creatorImg == nil){
            creatorImg = UIImage(named: "default.png")!
        }
        let avatarImage:UIImageView = UIImageView(image:creatorImg!.stretchableImageWithLeftCapWidth(86,topCapHeight:86));
        avatarImage.layer.cornerRadius = 43;
        avatarImage.layer.masksToBounds = true;

        retView.frame = CGRectMake(10,5,280,130);
        retView.addSubview(bimgView);
        retView.addSubview(titleLabel);
        retView.addSubview(timeLabel);
        retView.addSubview(placeLabel);
        retView.addSubview(contentLabel);
        retView.addSubview(creatorLabel);
        retView.addSubview(partiLabel);
        retView.addSubview(avatarImage);
        retView.addSubview(avatarImage);
        return retView;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell{
        let identifier:String = "sportcell";
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier)
    
        if (cell == nil) {
            cell = UITableViewCell(style:.Default ,reuseIdentifier:identifier)
            cell!.selectionStyle = .None;
        }else{
            for cellView:UIView in cell!.subviews {
                cellView.removeFromSuperview();
            }
        }
        cell!.addSubview(activeView(activePdu!.activeInfo![indexPath.row],row:indexPath.row));
/*        let sportCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath:indexPath);
        let titleLabel:UILabel = sportCell!.viewWithTag(1) as! UILabel;
        titleLabel.text = activePdu!.activeInfo![indexPath.row].title;

        let timeLabel:UILabel = sportCell!.viewWithTag(2) as! UILabel;
        timeLabel.text = "时间:\(activePdu!.activeInfo![indexPath.row].startTime!.subStringFrom(5).subStringTo(11))";

        let placeLabel:UILabel = sportCell!.viewWithTag(3) as! UILabel;
        placeLabel.text = "地点：\(activePdu!.activeInfo![indexPath.row].address!)";

        let contentLabel:UILabel = sportCell!.viewWithTag(4) as! UILabel;
        contentLabel.text = activePdu!.activeInfo![indexPath.row].introduce;

        let creatorLabel:UILabel = sportCell!.viewWithTag(5) as! UILabel;
        creatorLabel.text = activePdu!.activeInfo![indexPath.row].creatorName;

        let partiLabel:UILabel = sportCell!.viewWithTag(6) as! UILabel;
        var partiStr = "";
        if let num = activePdu!.activeInfo![indexPath.row].inmember {
            if(num > 0){
                partiStr = "已经有\(activePdu!.activeInfo![indexPath.row].inmember)人参与";
            }else{
                partiStr = "暂无人参与";
            }
        }else{
            partiStr = "暂无人参与";
        }
        partiLabel.text = partiStr;

        let avatarImage:UIImageView = sportCell!.viewWithTag(7) as! UIImageView;
        let imageUrl = activePdu!.activeInfo![indexPath.row].creatorAvatar;
        if(imageUrl != nil){
            if let aimage = UIImage(data:NSData(contentsOfURL:NSURL(string:imageUrl!)!)!) {
                avatarImage.image = aimage;
            }else{
                avatarImage.image = UIImage(named: "default.png")!
            }
        }else{
            let aimage:UIImage = UIImage(named: "default.png")!
            avatarImage.image = aimage;
        }
        avatarImage.contentMode = UIViewContentMode.ScaleAspectFill;
        sportCell!.layer.cornerRadius = 12;
        sportCell!.layer.masksToBounds = true;
        sportCell!.backgroundColor = indexPath.row % 2 == 1 ? UIColor.greenColor():UIColor.redColor();*/
        return cell!
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let active = activePdu!.activeInfo {
            print(active.count)
            return active.count
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //start a Chat
        
    }
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, indexPath: NSIndexPath){
        cell.backgroundColor = indexPath.row % 2 == 1 ? UIColor.greenColor():UIColor.redColor();
    }
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat{
        return 112;
    }

    @IBAction func changeQuerySort(sender: AnyObject) {
        let segBtn = sender as! UISegmentedControl
        switch segBtn.selectedSegmentIndex {
        case 0:
            activePdu!.setStringParameter("sort",value:"createtime desc");
            break;
        case 1:
            activePdu!.setStringParameter("sort",value:"distance desc");
            break;
        case 2:
            activePdu!.setStringParameter("sort",value:"member desc");
            break
        default:
            break
        }
        activePdu!.activeInfo!.removeAll()
        activePdu!.requestHttp();
    }
    @IBAction func createSportAction(sender: AnyObject) {
        self.performSegueWithIdentifier("login", sender: self)
    }
    //PduDelegate协议
    func reloadTable(){
        print("viewController reload data!!!");
        sportsList.reloadData();
    }
    func returnSuccess(actionId: String) {
        
    }
    func requestFailed(err: ErrInfo) {
        print(err.print());
    }

}

