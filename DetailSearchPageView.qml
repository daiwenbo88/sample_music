import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout{
    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 70
        color:"#00000000"
        Text{
            x:10
            verticalAlignment: Text.AlignBottom
            text:"搜索音乐"
            font.family: window.mFontFamily
            font.pointSize: 25
            color: "#eeffffff"
        }
    }
    RowLayout{
        Layout.fillWidth: true
        TextField{
            id:searchInput
            font.family: window.mFontFamily
            font.pointSize: 14
            selectByMouse: true//可以选中
            selectionColor: "#999999"
            placeholderText: "请输入搜索关键词"
            color: "#eeffffff"
            background: Rectangle{
                opacity:0.5 //透明度
                implicitHeight: 40
                implicitWidth: 400
                color:"#00000000"

            }
            focus: true
            Keys.onPressed: function(event){if(event.key===Qt.Key_Enter||event.key===Qt.Key_Return){
                                    doSearch()
                                }
            }
        }

        MusicIconButton{
            iconSource: "/icons/images/search"
            toolTip: "搜索"
            onClicked:{
                doSearch()
            }
        }
    }
    MusicListView{
        id:musicListView
        deleteble: false
        onLoadMoreData: function(offset){
            doSearch(offset)//
        }
        Layout.topMargin: 10
    }


    function doSearch(offset=0){
        var keywords= searchInput.text
        if(keywords.length===0){
            return
        }
        loading.open()
        if(offset===0){
            musicListView.all=0
            musicListView.musicList=[]
            musicListView.offset=0
            musicListView.current=0
        }
        function onReply(reply){
            http.onReplySignal.disconnect(onReply);//断开连接
            loading.close()
            try{
                if(reply.length<1){
                    notification.openError("搜索结果为空")
                    return
                }
                var result=JSON.parse(reply).result//.songs
                musicListView.all=result.songCount
                musicListView.musicList=result.songs.map(item=>{
                                                     return{
                                                         id:item.id,
                                                         name:item.name,
                                                         artist:item.artists[0].name,
                                                         album:item.album.name,
                                                         cover:""
                                                     }
                                                 })

            }catch(e){
                notification.openError("请求新歌推荐出错")

            }
        }
        http.onReplySignal.connect(onReply)//建立连接
        console.log("all="+musicListView.all)
        if(offset>musicListView.all){
            offset=musicListView.all
        }
         console.log("offset="+offset)
        http.doConnet("search?keywords="+keywords+"&offset="+offset+"&limit=60")//发起网络请求
    }

}

