import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
//DetailRecommendPageView


ScrollView{
    clip: true
    ColumnLayout {
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: window.mFontFamily
                font.pointSize: 25
                color: "#eeffffff"
            }
        }

        MusicBannerView{
            id:bannerView
            Layout.preferredWidth: window.width-200
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFontFamily
                font.pointSize: 25
                color: "white"
            }
        }

        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.2*4+30*4+20
            Layout.bottomMargin: 20
        }


        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: window.mFontFamily
                font.pointSize: 25
                color: "white"
            }
        }


        MusicGridLatestView{
            id:latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }

    }

    Component.onCompleted: {
        getBannerList()
    }

    function getBannerList(){
        loading.open()
        function onReply(reply){
            //console.log(reply)
            http.onReplySignal.disconnect(onReply);//断开连接
            try{
                if(reply.length<1){
                    notification.openError("请求轮播图为空")
                    loading.close()
                    return
                }
                var bannerList=JSON.parse(reply).banners
                bannerView.bannerList= bannerList.map(item=>{
                                                          return{
                                                              imageUrl:item.imageUrl,
                                                              targetId:item.targetId,
                                                              targetType:item.targetType,
                                                          }
                                                      })
                getHotList()
            }catch(e){
                getHotList()
                notification.openError("请求轮播图出错")
            }

        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("banner")//发起网络请求
    }

    function getHotList(){
        function onReply(reply){           
            http.onReplySignal.disconnect(onReply);//断开连接
            try{
                if(reply.length<1){
                    notification.openError("热门歌单为空")

                    return
                }
                var playLists=JSON.parse(reply).playlists
                console.log("playLists="+playLists.length)
                hotView.list=playLists
                getLatestList()
            }catch(e){
                getLatestList()
                notification.openError("请求热门歌单出错")
            }

        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("top/playlist/highquality?limit=20")//发起网络请求
    }

    function getLatestList(){
        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply);//断开连接
            try{
                if(reply.length<1){
                    notification.openError("新歌推荐为空")
                    loading.close()
                    return
                }
                var list=JSON.parse(reply).data
                console.log("list="+list.length)
                var latestList=[]
                for(var i=0;i<20;i++){
                    // console.log(bannerList[i].imageUrl)
                    //latestList.push(list[i].album)
                    latestList.push({
                                        id:list[i].id,
                                        name:list[i].name,
                                        artist:list[i].album.artists[0].name,
                                        album:list[i].album.name,
                                        cover:list[i].album.picUrl
                                    })
                }
                latestView.list=latestList

            }catch(e){

                notification.openError("请求新歌推荐出错")
            }
            loading.close()
        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("top/song")//发起网络请求
    }
}




