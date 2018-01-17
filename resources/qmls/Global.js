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

//解析api标准格式数据
function resolveStandardData(ori_data){
    if(ori_data !== null){
        console.log("接收到API返回数据:" + ori_data);

        var obj = runFuncWithUseTime(JSON.parse, "JSON.parse", ori_data);
        var code = obj.code;
        var msg = obj.msg;
        var data = obj.data;

        console.log(code,msg, data)

        if(code !== null && msg !== null){
            return [true, obj.code, obj.msg, obj.data];
        }
    }

    return [false, -1, "不能解析数据格式", null];
}

function resolveSearchResult(data)
{
    //console.log("Search result-->", data);
    var json_obj = resolveStandardData(data);

    if(json_obj[0])
    {
        var code = json_obj[1];
        var msg = json_obj[2];
        if(code === 0)
        {
            var items = json_obj[3];
            var model_data = [];
            for(var i = 0; i<items.length; i++)
            {
                //console.log(items[i]);
                var item = items[i];


                //console.log(item.id, item.image, item.new, item.source);

                model_data.push({"itemID": item.id, "newOne": item.new, "image": item.image, "title": item.title, "sourcePage":item.source});


            }

            return [true, model_data]
        }
    }

    return [false]
}

/*
  解析图片分组中的图片数据
*/
function resolveItemsDetailData(images_data)
{


    var json_obj = resolveStandardData(images_data);

    if(json_obj[0])
    {
        var code = json_obj[1]
        var msg = json_obj[2]
        if(code === 0)
        {
            var model_data = [];

            var childlist = json_obj[3].images;

            for(var j = 0; j<childlist.length; j++)
            {
                var item = childlist[j];


                //console.log("image_url:", item);
                model_data.push({ "image": item.image, "imageid": item.id});
            }

            return [true, model_data];
        }
        else
        {
            console.warn("Failed request classifies data: "+msg);
        }
    }

    return [false, []];
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
