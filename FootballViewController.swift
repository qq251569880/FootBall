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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell{
        let cellId:String = "sportcell";
        let sportCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath:indexPath);
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
        sportCell!.backgroundColor = indexPath.row % 2 == 1 ? UIColor.greenColor():UIColor.redColor();
        return sportCell!
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
        
    }

}

