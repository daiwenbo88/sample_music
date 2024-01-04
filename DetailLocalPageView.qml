import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import Qt.labs.settings
import QtQml
ColumnLayout{
    Settings{
       id:localSttings
       fileName:"conf/local.ini"

    }
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color:"#00000000"
        Text{
            x:10
            verticalAlignment: Text.AlignBottom
            text:"本地音乐"
            font.family: window.mFontFamily
            font.pointSize: 25
            color: "#eeffffff"
        }
    }
    RowLayout{
        height: 80
        Item {
            width: 10
        }
        MusicTextButton{
            btnText: "添加本地音乐"
            btnHeight: 50
            btnWidth: 200
            onClicked: {
                fileDialog.open()
            }
        }
        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                getLocal()
            }
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                saveLocal("")
            }
        }

    }

    MusicListView{
        id:localListView
         onDeleteItem:function(index){
            deleteLocal(index)
         }
    }
    Component.onCompleted: {
        getLocal()

    }
    function deleteLocal(index){
        localListView.musicList.splice(index,1)
        saveLocal(JSON.stringify(localListView.musicList))
    }
    function getLocal(){
        var list= localSttings.value("local",[])
        console.log("getList= "+list)
        if(list.length>0){
            localListView.musicList=JSON.parse(list)
        }else{
            localListView.musicList=[]
        }
    }

    function saveLocal(list){
        console.log("savelist= "+list)
        localSttings.setValue("local",list)
        getLocal()
    }


    FileDialog{
        id:fileDialog
        fileMode: FileDialog.OpenFiles//多选文件
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC Music File(*.flac)"]//筛选文件种类
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]//默认打开路径
        acceptLabel: "确定"
        rejectLabel: "取消"
        onAccepted: {
            var list=[]
            for(var index in files){
                var path=files[index]
                console.log("path="+path)
                var arr=path.toString().split("/")
                var fileNameArr=arr[arr.length-1].split(".")
                fileNameArr.pop()//删除后缀
                var fileName=fileNameArr.join(".")
                var nameArr=fileName.split("-")

                console.log("fileName= "+fileName)
                console.log("nameArr= "+nameArr)
                var name=""
                var artist=""
                if(nameArr.length>1){
                    artist=nameArr[0]
                    nameArr.shift()
                }
                name=nameArr.join("-")
                console.log("nameArr="+nameArr)
                console.log("name="+name)

                list.push({
                          id:path+"",
                          name,
                          artist,
                          url:path+"",
                          album:"本地音乐",
                          type:"1",
                          cover:"icons/images/player"
                          })
            }
            saveLocal(JSON.stringify(list))
            //localListView.musicList=list
        }
    }

}
