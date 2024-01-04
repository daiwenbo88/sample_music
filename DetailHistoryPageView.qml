import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import Qt.labs.settings
import QtQml

ColumnLayout{

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color:"#00000000"
        Text{
            x:10
            verticalAlignment: Text.AlignBottom
            text:"历史播放"
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
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                getHistoryLit()
            }
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                saveHistoryLit("")
            }
        }

    }

    MusicListView{
        id: historyListView
         onDeleteItem:function(index){
            deleteHistory(index)
         }
    }
    Component.onCompleted: {
        getHistoryLit()

    }
    function deleteHistory(index){
        historyListView.musicList.splice(index,1)
        saveHistoryLit(JSON.stringify(historyListView.musicList))
    }
    function getHistoryLit(){
        var list= historySttings.value("history","")
        console.log("getHistoryLit= "+list)
        if(list.length>0){
            historyListView.musicList=JSON.parse(list)
        }else{
            historyListView.musicList=[]
        }
    }

    function saveHistoryLit(list){
        console.log("saveHistoryLit= "+list)
        historySttings.setValue("history",list)
        getHistoryLit()
    }
}

