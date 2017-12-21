.pragma library

var mainForm = null; //主页面
var safeUrl = ""; //反防盗链url

//函数运行计时
function runFuncWithUseTime(func, funcname){
    var start = new Date().getTime();//起始时间
    var pars = [];
    for (var i = 0; i<arguments.length; i++){
        pars.push(arguments[i]);
    }

    //console.log("runFuncWithUseTime arguments:", pars, typeof(pars), arguments.length);
    pars.splice(0, 2);

    //console.log("runFuncWithUseTime->pars:", pars);
    var result = func.apply(this, pars);
    var end = new Date().getTime();//接受时间

    console.log("===> Run", "<"+funcname+">", "use time(s):", (end-start)/1000,"(", start/1000, ",", end/1000, ")");
    return result
}

//解析api标准格式数据
function resolveStandardData(standData)
{
    //console.log("Resolve standard data:", standData);
    if(standData !== undefined)
    {
        var json_obj = runFuncWithUseTime(JSON.parse, "JSON.parse", standData);

        if(json_obj !== null)
        {
            return [true, json_obj.code, json_obj.msg, json_obj.data];
        }
        else
        {
            console.warn("Failed resolve standard data! Invalid json data!")
        }
    }
    else
    {
        console.warn("Failed resolve standard data! Invalid data!")
    }

    return [false];
}

/*
    解析分类数据
    return: [成功标志, 分类信息数组]
          例如[true, [{"id":0, "name":"分组1"}, {"id":1, "name":"分组2"}]]
*/
function resolveClassifiesData(json_string)
{
    var json_obj = resolveStandardData(json_string);

    if(json_obj[0])
    {
        var code = json_obj[1]
        var msg = json_obj[2]
        if(code === 0)
        {
            var model_data = [];

            var childlist = json_obj[3].list;

            for(var j = 0; j<childlist.length; j++)
            {
                var classify = childlist[j];

                //console.log(classify.id, classify.name, classify.referer);

                model_data.push({"id": classify.id, "name":classify.name, "referer":classify.referer});
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

/*
  解析图片分组数据
*/
function resolvePageData(items_data, referer)
{
    var json_obj = resolveStandardData(items_data);

    if(json_obj[0])
    {
        var code = json_obj[1]
        var msg = json_obj[2]
        if(code === 0)
        {
            var model_data = [];
            var childlist = json_obj[3].items;

            var limit = arguments[2] ? arguments[2] : -1

            for(var j = 0; j<childlist.length; j++)
            {
                var item = childlist[j];

                var image_url = (referer ? safeUrl:"")+item.image
                //console.log(item.id, image_url, item.name, item.source);

                model_data.push({"itemID": item.id, "image": image_url, "title": item.name, "sourcePage":item.source});

                if (limit > 0 && j>=(limit-1))
                {
                    break;
                }
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

/*
  解析图片分组中的图片数据
*/
function resolveItemsDetailData(images_data, referer)
{
    var json_obj = resolveStandardData(images_data);

    if(json_obj[0])
    {
        var code = json_obj[1]
        var msg = json_obj[2]
        if(code === 0)
        {
            var model_data = [];

            var childlist = json_obj[3];

            for(var j = 0; j<childlist.length; j++)
            {
                var item = childlist[j];



                var image_url = (referer ? safeUrl:"")+item

                console.log("image_url:", image_url);
                model_data.push({ "image": image_url});
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
    console.log("fixedDirName: ", old, "->", temp);
    return temp;
}
