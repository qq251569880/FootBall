

class PtnActiveHistoryPDU :PtnPDU
{
	var queryBody:PtnQueryBody?
	var historyInfo:Array<HistoryInfo>?
	override init(){
		super.init();
	}
	init(url:String){
		super.init();
        historyInfo = [];
		requestUrl = url;
	}
	//继承类实现该函数
	override func decodeReturnBody(){
		queryBody = PtnQueryBody(responseJson!.body!);
        if let list = queryBody!.list{
            if let lists = list.array {
                for activeinfo in lists {
                    historyInfo!.append(HistoryInfo(activeinfo));
                }
            }
        }
		delegate?.reloadTable();
	}
}
