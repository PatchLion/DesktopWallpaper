.pragma library





//页面数据缓存
function PageDataCache()
{
    this.classifyInfo = {}; //分类信息
    this.pageDatas = {}; //页面数据
    this.itemDatas = {}; //单项数据

    //添加页面数据
    this.pushPageData = function(classifyID, pageIndex, json_string){
        if(page_data === null || page_data.length === 0)
        {
            return [false, []];
        }

        var json_object = JSON.parse(page_data);

        var page_infos = json_object.showapi_res_body.pagebean;
        if(page_infos)
        {
            var allPages = page_infos.allPages; //分类总页面数
            var contentlist = page_infos.contentlist; //内容列表
            var currentPage = page_infos.currentPage; //当前页序号
            var allNum = page_infos.allNum; //总的图片组数量
            var maxResult = page_infos.maxResult; //最大返回数量

            this.classifyInfo[classifyID] = [allPages, allNum];

            return [true, contentlist];
        }

        return [false, []];
    }

    //查找页面
    this.findPage = function(classify, page){
        console.log(classify, page)
    }

    //查找单项
    this.findItem = function(itemID){

    }
}

//页面数据缓存
var pageDataCache = new PageDataCache();


