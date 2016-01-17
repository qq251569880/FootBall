import JSONJoy


enum ParaType{
	case String
	case File
	case Array
}

struct Parameter{
	var type:ParaType?;
	var name:String?;
	
	var value:String?;
	var path:String?;
	var array:Array<String>?;
	init(){
	}
}

struct PtnJsonErr:JSONJoy{
	var errorcode:Int?
	var description:String?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        errorcode=decoder["errorcode"].integer;
        description=decoder["description"].string;
    }
}
struct PtnJsonParam:JSONJoy{
	var paramDic:Dictionary<String,String>?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        
        decoder.getDictionary(&paramDic)
    }
}
struct PtnJsonHead:JSONJoy{
	var status:Int?;
	var error:PtnJsonErr?
	var params:PtnJsonParam?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        status=decoder["status"].integer;
        if(status == 0){
			params = PtnJsonParam(decoder["params"])
        }else{
			error = PtnJsonErr(decoder["error"])
        }
        
    }
}

struct PtnJson:JSONJoy{
	var head:PtnJsonHead?
	var body:JSONDecoder?
    init() {

    }
    init(_ decoder: JSONDecoder) {
        head=PtnJsonHead(decoder["head"]);
        body=decoder["body"];
    }
}
protocol PduDelegate{
	func reloadTable();
    func returnSuccess(actionId:String);
    func requestFailed(err:ErrInfo)
}
class PtnPDU
{
	var requestUrl:String?;
	var accessToken:String?;
	var requestMethod = "POST";
	var parameterList:[Parameter];
    var requestHeader:[String:String]?;
    var actionId:String?;
	
	var responseData:NSData?;
	var responseJson:PtnJson?;
	var delegate:PduDelegate?
	init(){
        parameterList = [];
	}
	func setUrl(url:String)
	{
		requestUrl = url;
	}
	func setToken(token:String)
	{
		accessToken = token;
	}
    func setActionId(actionid:String){
        actionId =  actionid;
    }
	func getParameterByName(name:String) -> Parameter?{
		for para in parameterList {
			if para.name == name {
				return para
			}
		}
		return nil;
	}
	func setStringParameter(name:String,value:String)
	{
		var para:Parameter? = getParameterByName(name)
		if para == nil{
			para = Parameter();
			para!.name=name;
			para!.value=value;
			para!.type = .String;
			parameterList.append(para!);
		}else{
			para!.value=value;
			para!.type = .String;
		}
	}
	func setFileParameter(name:String,path:String)
	{
		var para:Parameter? = getParameterByName(name)
		if para == nil{
			para = Parameter();
			para!.name=name;
			para!.path=path;//路径名
			para!.type = .File;
			parameterList.append(para!);
		}else{
			para!.path=path;//路径名
			para!.type = .File;
		}
	}
	func setArrayParameter(name:String,array:Array<String>)
	{
		var para:Parameter? = getParameterByName(name)
		if para == nil{
			para = Parameter();
			para!.name=name;
			para!.type = .Array;
			para!.array = array;
			parameterList.append(para!);
		}else{
			para!.type = .Array;
			para!.array = array;
		}
	}
    func setHeader(key:String,value:String){
        requestHeader = [key:value];
    }
	func clearParameter()
	{
		parameterList.removeAll();
	}
	func unsetParameter(name:String)
	{
		var pos:Int = 0;
		for para in parameterList {
			if para.name == name {
				parameterList.removeAtIndex(pos)
				break;
			}
			pos++;
		}
	}
	
	func requestHttp()
	{
		do {
			if(requestMethod == "POST"){
                var params:Dictionary<String,AnyObject> = [:];
				for param in parameterList{
					if(param.type == .File){
						let url = NSURL(fileURLWithPath: param.path!)
						params.updateValue(Upload(fileUrl: url), forKey:param.name!)  
					}else if(param.type == .Array){
						params.updateValue(param.array!, forKey:param.name!)
					}else{
						params.updateValue(param.value!, forKey:param.name!)
					}
				}
				
                let opt = try HTTP.POST(requestUrl!, parameters: params,headers:requestHeader)
				opt.start { response in
					if let error = response.error {
						print("response got an error: \(error)");
                        let err = ErrInfo(code:ERR_REQUEST_RESPONSE,info:"response got an error: \(error)");
						self.delegate!.requestFailed(err);
					}
                    self.decodeResponse(JSONDecoder(response.data))
				}
			}
		} catch let error {
			print("catch got an error: \(error)")
            let err = ErrInfo(code:ERR_REQUEST_EXCEPTION,info:"catch got an error: \(error)");
			delegate!.requestFailed(err);
		}		
		
	}
	func decodeResponse(decoder: JSONDecoder){
		
		responseJson = PtnJson(decoder);
		//解析响应，获得status
		if let statu = responseJson!.head!.status {
			if( statu == 0){
				if responseJson!.body != nil {
					decodeReturnBody();
                }else{
                    decodeNoBodySucc();
                }
			}else{
			    print("server returned err ");
                if let _err = responseJson!.head!.error{
                    let err = ErrInfo(code:_err.errorcode!,info:"server returned err: \(_err.description)");
			        delegate!.requestFailed(err);
                }
			}
		}else{
			print("decode json failed ");
			delegate!.requestFailed(jsonFailed);
		}
	}
	//由继承类实现该函数
	func decodeReturnBody(){
	}
    func decodeNoBodySucc(){
    }
}