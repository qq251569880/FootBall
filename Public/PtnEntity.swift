import JSONJoy
struct PtnQueryBody: JSONJoy{
	var numfound:Int?;
	var start:Int?;
	var list:JSONDecoder?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        numfound = decoder["numfound"].integer
        start = decoder["start"].integer
        if let num = numfound {
			if(num > 0){
				list = decoder["list"]
			}
        }
	}	
}
struct PtnCreateBody:JSONJoy{
	var objectId:String?;
	var objectValue:String?;
	init(){
	}
	init(_ decoder:JSONDecoder) {
		objectValue = decoder[objectId!].string;
	}
    init( decoder: JSONDecoder,id:String) {
        objectId = id;
        objectValue = decoder[objectId!].string;
    }
}
struct PtnLoginBody:JSONJoy{
	var accessToken:String?;
	var userId:String?;
	init(){
	}
	init(_ decoder:JSONDecoder) {
		accessToken = decoder["token"].string;
		userId = decoder["accountId"].string;
	}
}
struct ActiveInfo: JSONJoy
{
    var activeId:String?
    var creatorId:String?
    var title:String?
    var type:String?
    var state:String?
    var placeId:String?
    var maxMember:String?
    var introduce:String?
    var createTime:String?
    var startTime:String?
    var endTime:String?
    var member:Int?
    var inmember:Int?
    var joined:String?
    var partiState:String?
    var partiResult:String?
    var creatorName:String?
    var creatorAvatar:String?
    var country:String?
    var province:String?
    var city:String?
    var area:String?
    var address:String?
    var latitude:Float?
    var longitude:Float?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        activeId = decoder["activeid"].string
        creatorId = decoder["creatorid"].string
        title = decoder["title"].string
        type = decoder["type"].string
        state = decoder["state"].string
        placeId = decoder["placeid"].string
        maxMember = decoder["maxmember"].string
        introduce = decoder["introduce"].string
        createTime = decoder["createtime"].string
        startTime = decoder["starttime"].string
        endTime = decoder["endtime"].string
        member = decoder["member"].integer
        inmember = decoder["inmember"].integer
        joined = decoder["joined"].string
        partiState = decoder["partistate"].string
        partiResult = decoder["partiresult"].string
        creatorName = decoder["creatorname"].string
        creatorAvatar = decoder["creatoravatar"].string
        country = decoder["country"].string
        province = decoder["province"].string
        city = decoder["city"].string
        area = decoder["area"].string
        address = decoder["address"].string
        latitude = decoder["latitude"].float
        longitude = decoder["longitude"].float
        id = decoder["id"].integer
    }

}
struct HistoryInfo: JSONJoy
{
    var activeId:String?
    var title:String?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        activeId = decoder["activeid"].string
        title = decoder["title"].string
        id = decoder["id"].integer
    }
}

struct ActivePlace
{
    var placeId:String?
    var country:String?
    var province:String?
    var city:String?
    var area:String?
    var address:String?
    var latitude:Float?
    var longitude:Float?
    var introduce:String?
    var picture:String?
    var price:String?
    var createTime:String?
    var updateTime:String?
    var creator:String?
    var adminName:String?
    var adminMobile:String?
    var state:String?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        
		placeId = decoder["placeid"].string
		country = decoder["country"].string
		province = decoder["province"].string
		city = decoder["city"].string
		area = decoder["area"].string
		address = decoder["address"].string
		introduce = decoder["introduce"].string
		picture = decoder["picture"].string
		latitude = decoder["latitude"].float
		longitude = decoder["longitude"].float
		price = decoder["price"].string
		createTime = decoder["createtime"].string
		updateTime = decoder["updatetime"].string
		creator = decoder["creator"].string
		adminName = decoder["adminname"].string
		adminMobile = decoder["adminmobile"].string
		state = decoder["state"].string
		id = decoder["nindex"].integer
	}
}
struct ActiveUser
{
    var activeId:String?
    var userId:String?
    var state:String?
    var stateTime:String?
    var joinGroup:String?
    var joinMessage:String?
    var joinNumber:String?
    var result:String?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
		activeId = decoder["activeid"].string
		userId = decoder["userid"].string
		state = decoder["state"].string
		stateTime = decoder["statetime"].string
		result = decoder["result"].string
		joinGroup = decoder["joingroup"].string
		joinMessage = decoder["joinmessage"].string
		joinNumber = decoder["joinnumber"].string
		id = decoder["nindex"].integer
    }
}
struct ChatMessage
{
    var messageId:String?
    var activeId:String?
    var userId:String?
    var messageType:String?
    var content:String?
    var path:String?
    var sendTime:String?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
		activeId = decoder["activeid"].string
		messageId = decoder["messageid"].string
		userId = decoder["userid"].string
		messageType = decoder["messagetype"].string
		content = decoder["content"].string
		path = decoder["path"].string
		sendTime = decoder["sendtime"].string
		id = decoder["nindex"].integer
    }
    
}
struct Comment
{
    var commentId:String?
    var messageId:String?
    var userId:String?
    var content:String?
    var praise:String?
    var commentTime:String?
    var id:Int?
}
struct LoginSession
{
    var sessionId:String?
    var userId:String?
    var createTime:String?
    var updateTime:String?
    var userType:String?
    var deviceType:String?
    var id:Int?
}
struct UserInfo
{
    var userId:String?
    var mobile:String?
    var email:String?
    var nickName:String?
    var birth:String?
    var sex:String?
    var avatar:String?
    var country:String?
    var province:String?
    var city:String?
    var address:String?
    var favor:String?
    var introduce:String?
    var registerTime:String?
    var updateTime:String?
    var id:Int?
    init() {

    }
    init(_ decoder: JSONDecoder) {
		userId   = decoder["userid"].string
		mobile = decoder["mobile"].string
		email  = decoder["email"].string
		birth  = decoder["birth"].string
		nickName = decoder["nickname"].string
		sex  = decoder["sex"].string
		avatar = decoder["avatar"].string
		country = decoder["country"].string
		province = decoder["province"].string
		city = decoder["city"].string
		address = decoder["address"].string
		favor  = decoder["favor"].string
		introduce = decoder["introduce"].string
		registerTime = decoder["registertime"].string
		updateTime  = decoder["updatetime"].string
		id = decoder["nindex"].integer
    }
}
