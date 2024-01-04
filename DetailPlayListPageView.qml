import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout{
    property string targetId: ""
    property string targetType: "10"
    property string name: "-"

    onTargetIdChanged: {
        if(targetId.length<1)
            return
        getList()
    }
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 70
        color:"#00000000"
        Text{
            x:10
            verticalAlignment: Text.AlignBottom
            text:targetType=="10"?"专辑":"歌单"+name
            font.family: window.mFontFamily
            font.pointSize: 25
            color: "#eeffffff"
        }
    }

    RowLayout{
        height: 200
        width: parent.width

        MusicRundImage{
            id:playListCover
            width: 180
            height: 180
            Layout.leftMargin:15
        }
        Item {
            Layout.fillWidth: true
            height: parent.height
            Text {
                id: playListDec
                text: qsTr("text")// This is available in all editors.
                width: parent.width*0.95
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.family: window.mFontFamily
                font.pointSize: 18
                maximumLineCount: 4//最多4行
                elide: Text.ElideRight
                color: "#eeffffff"
                //lineHeight: 1.5//行间距
            }
        }

    }
    MusicListView{
        id:playListView
        onDeleteItem:function(index){
            deletePlayListItem(index)
        }
    }

    function deletePlayListItem(index){
        playListView.musicList.splice(index,1)
        playListView.musicList=playListView.musicList
    }

    function getList(){
        console.log("targetId="+targetId+" targetType="+targetType)
        if(targetType=="10"){//歌单详情
            getAlbumList()
        }else{//专辑内容
            getPlayList()
        }
    }
    //歌单详情
    function getPlayList(){

        function onReply(reply){
            http.onReplySignal.disconnect(onReply);//断开连接
            var playlist=JSON.parse(reply).playlist
            playListCover.imgSrc=playlist.coverImgUrl
            playListDec.text=playlist.description
            name="-"+playlist.name
            playListView.musicList=playlist.tracks.map(item=>{
                                                           return{
                                                               id:item.id,
                                                               name:item.name,
                                                               artist:item.ar[0].name,
                                                               album:item.al.name,
                                                               cover:(item.al.picUrl.length>0)?item.al.picUrl:""
                                                           }
                                                       })
            //console.log("list="+musicListView.musicList.length)
            //console.log(bannerList.length)
        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("playlist/detail?id="+targetId)//发起网络请求
    }
    //专辑内容
    function getAlbumList(){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply);//断开连接
            var album=JSON.parse(reply).album
            playListCover.imgSrc=album.blurPicUrl
            playListDec.text=album.description
            name="-"+album.name

            //playListView.all=album.songCount
            playListView.musicList=album.songs.map(item=>{
                                                       return{
                                                           id:item.id,
                                                           name:item.name,
                                                           artist:item.ar[0].name,
                                                           album:item.al.name,
                                                           cover:(item.al.picUrl.length>0)?item.al.picUrl:""
                                                       }
                                                   })
        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("album?id="+targetId)
    }
}
