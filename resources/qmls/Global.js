.pragma library

var mainForm = null; //主页面

//解析api标准格式数据
function resolveStandardData(standData)
{
    console.log("Resolve standard data:", standData);
    if(standData !== undefined)
    {
        var json_obj = JSON.parse(standData);

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

                console.log(classify.id, classify.name);

                model_data.push({"id": classify.id, "name":classify.name});
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
function resolveItemsData(items_data)
{
    var json_obj = resolveStandardData(items_data);

    if(json_obj[0])
    {
        var code = json_obj[1]
        var msg = json_obj[2]
        if(code === 0)
        {
            var model_data = [];

            var limit = arguments[1] ? arguments[1] : -1;
            var childlist = json_obj[3].list;

            for(var j = 0; j<childlist.length; j++)
            {
                var item = childlist[j];

                console.log(item.id, item.image, item.classify, item.name);

                model_data.push({"itemID": item.id, "image": item.image, "classify":item.classify, "title": item.name});

                if(limit > 0 && model_data.length ===limit)
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

            var childlist = json_obj[3].list;

            for(var j = 0; j<childlist.length; j++)
            {
                var item = childlist[j];

                //console.log(item.id, item.image, item.classify, item.name);

                model_data.push({ "image": item});
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
