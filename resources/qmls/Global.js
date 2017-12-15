.pragma library

var mainForm = null; //主页面

/*
    解析分类数据
    return: [成功标志, 分类信息数组]
          例如[true, [{"id":0, "name":"分组1"}, {"id":1, "name":"分组2"}]]
*/
function resolveClassifiesData(json_string)
{
    if (json_string.length === 0)
    {
        return [false, []];
    }

    var json_obj = JSON.parse(json_string);
    if(json_obj)
    {
        var classifies = json_obj["showapi_res_body"]["list"];

        var model_data = [];
        if(classifies)
        {
            for(var i = 0; i < classifies.length; i++)
            {
                var childlist = classifies[i].list;

                for(var j = 0; j<childlist.length; j++)
                {
                    var classify = childlist[j];

                    //if(classify.id >= 4000 && classify.id <= 4999)
                    //{
                        console.log(classify.id, classify.name);

                        model_data.push({"id": classify.id, "name":classify.name});
                    //}
                }
            }
        }

        return [true, model_data];
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
