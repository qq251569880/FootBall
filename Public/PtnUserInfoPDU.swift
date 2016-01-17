

class PtnUserInfoPDU :PtnPDU
{
	var queryBody:PtnQueryBody?
	var userInfo:Array<UserInfo>?
	override init(){
		super.init();
	}
	init(url:String){
		super.init();
        userInfo = [];
		requestUrl = url;
	}
	//继承类实现该函数
	override func decodeReturnBody(){
		queryBody = PtnQueryBody(responseJson!.body!);
        if let list = queryBody!.list{
            if let lists = list.array {
                for userinfo in lists {
                    userInfo!.append(UserInfo(userinfo));
                }
            }
        }
		delegate?.reloadTable();
	}
}
