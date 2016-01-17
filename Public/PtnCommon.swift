
let serverUrl:String = "http://yuyanshu.cn:8001/app.php/"
enum RequestRet{
	case ResponseErr
	case JsonDecodeErr
	case RetStatusErr
	case BodyDecodeErr
	case CatchErr
}

struct ErrInfo{
    var errCode:Int;
    var errInfo:String;
    init(code:Int,info:String){
        errCode = code;
        errInfo = info;
    }
}
enum RegPassAction{
    case Register
    case ChangePassword
    case ForgotPassword
}

let ERR_JSON_DECODE:Int = 1001;
let ERR_REQUEST_RESPONSE:Int = 1002;
let ERR_REQUEST_EXCEPTION:Int = 1003;


let jsonFailed:ErrInfo = ErrInfo(code:ERR_JSON_DECODE,info:"decode json string failed");
let requestFailed:ErrInfo = ErrInfo(code:ERR_REQUEST_RESPONSE,info:"Http requestFailed");

