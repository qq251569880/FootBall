

class PtnActiveInfoQueryPDU :PtnPDU
{
	var queryBody:PtnQueryBody?
	var activeInfo:Array<ActiveInfo>?
	override init(){
		super.init();
	}
	init(url:String){
		super.init();
        activeInfo = [];
		requestUrl = url;
	}
	//继承类实现该函数
	override func decodeReturnBody(){
		queryBody = PtnQueryBody(responseJson!.body!);
        if let list = queryBody!.list{
            if let lists = list.array {
                for activeinfo in lists {
                    activeInfo!.append(ActiveInfo(activeinfo));
                }
            }
        }
		delegate?.reloadTable();
	}
	func setSportListViewFields(){
		self.setStringParameter("fields",value:"activeid,title,creatorname,creatoravatar,introduce,starttime,country,province,city,area,address,inmember");
	}
	func setHistoryViewFields(){
		self.setStringParameter("fields",value:"activeid,title,creatorname,creatoravatar,introduce,starttime,country,province,city,area,address,inmember");
	}
}
