.pragma library

var RootPanel = null; //根页面

//函数运行计时
function runFuncWithUseTime(func, funcname){
    var start = new Date().getTime();//起始时间
    var pars = [];
    for (var i = 0; i<arguments.length; i++){
        pars.push(arguments[i]);
    }
    pars.splice(0, 2);
    var result = func.apply(this, pars);
    var end = new Date().getTime();//结束时间

    console.log("===> Run", "<"+funcname+">", "use time(s):", (end-start)/1000,"(", start/1000, ",", end/1000, ")");
    return result;
}

/*
  解析生成API回调后结果
  返回值[true, 数据]或[false, 错误消息]
*/
function resolveAPIResponse(suc, msg, data){
    var isPrintDebug = arguments[3] ? arguments[3] : false;//默认值为false 不打印Debug信息
    if(suc){
        return resolveStandardData(data, isPrintDebug);
    }
    else{
        return [false, msg];
    }
}

/*
  解析api标准格式数据
  返回值[true, 数据]或[false, 错误消息]
*/
function resolveStandardData(ori_data){
    var result = [false, "不能解析数据格式"];
    var isPrintDebug = arguments[1] ? arguments[1] : false;//默认值为false 不打印Debug信息
    if(isPrintDebug){
        console.log("接收到API返回数据:" + ori_data);
    }
    if(ori_data !== null){
        var obj = runFuncWithUseTime(JSON.parse, "JSON.parse", ori_data);
        var code = obj.code;
        var msg = obj.msg;
        var data = obj.data;

        //console.log(code,msg, data)

        if(code !== null && msg !== null){
            if (code === 0){
                result = [true, data];
            }
            else{
                result = [false, msg];
            }

        }
    }

    if(isPrintDebug){
        console.log("解析结果:", result[0], (!result[0] ? result[1] : "<data>"));
    }
    return result;
}

//根据返回数据生成Model数据源
/*
  分类Model数据
*/
function toClassifiesModelData(data){
    var childlist = data;

    var model_data = [];
    for(var j = 0; j<data.length; j++)
    {
        var classify = data[j];

        model_data.push({"name":classify});
    }

    return model_data;
}

/*
  分页Model数据
*/
function toPageModelData(data){

    var model_data = [];
    var childlist = data.items;
    var limit = arguments[1] ? arguments[1] : -1;//默认值为-1

    //console.log("Page model limit =", limit, arguments[0], arguments[1]);

    for(var j = 0; j<childlist.length; j++){
        var item = childlist[j];

        //console.log("Page data:", item.id, item.new, /*item.image, */item.title, item.source);

        model_data.push({"itemID": item.id,
                            "newOne": item.new,
                            "image": item.image,
                            "title": item.title,
                            "sourcePage":item.source});

        if (limit > 0 && j>=(limit-1)){
            //console.log("BBBBBBBBBreak!!!!!!!!!!!!!!!")
            break;
        }
    }

    return model_data;
}


/*
  收藏Model数据
*/
function toPefersModelData(data){

    var model_data = [];
    var childlist = data.items;
    var limit = arguments[1] ? arguments[1] : -1;//默认值为-1

    //console.log("Page model limit =", limit, arguments[0], arguments[1]);

    for(var j = 0; j<childlist.length; j++){
        var item = childlist[j].info;

        //console.log("Page data:", item.id, item.new, /*item.image, */item.title, item.source);

        model_data.push({"itemID": item.id,
                            "newOne": item.new,
                            "image": item.image,
                            "title": item.title,
                            "sourcePage":item.source});

        if (limit > 0 && j>=(limit-1)){
            //console.log("BBBBBBBBBreak!!!!!!!!!!!!!!!")
            break;
        }
    }

    return model_data;
}

/*
  图片列表Model数据
*/
function toImageDetailsModelData(data){
    var model_data = [];

    var childlist = data.images;

    for(var j = 0; j<childlist.length; j++)
    {
        var item = childlist[j];
        model_data.push({ "image": item.image, "imageid": item.id});
    }

    return model_data;
}

//关闭临时面板
function destroyPanel(panel){
    panel.visible = false;
    panel.destroy();
    panel = null;
}

//替换文件或目录名中无效的字符
function fixedDirName(old)
{
    var temp = old;
    var chars = "[/:*?《》<>\"\f\n\r\t\v]";

    temp = temp.replace(new RegExp(chars,"g"), "_");
    //console.log("fixedDirName: ", old, "->", temp);
    return temp;
}
