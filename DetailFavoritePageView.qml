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
            text:"我喜欢的"
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
                getFavoriteLit()
            }
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                saveFavoriteLit("")
            }
        }

    }

    MusicListView{
        id: favoriteListView
        favoritable: false
         onDeleteItem:function(index){
            deleteFavorite(index)
         }
    }
    Component.onCompleted: {
        getFavoriteLit()

    }
    function deleteFavorite(index){
        favoriteListView.musicList.splice(index,1)
        saveFavoriteLit(JSON.stringify(favoriteListView.musicList))
    }
    function getFavoriteLit(){
        var list=favoriteSttings.value("favorite","")
        console.log("getFavoriteLit= "+list)
        if(list.length>0){
            favoriteListView.musicList=JSON.parse(list)
        }else{
            favoriteListView.musicList=[]
        }
    }

    function saveFavoriteLit(list){
        console.log("saveFavoriteLit= "+list)
        favoriteSttings.setValue("favorite",list)
        getFavoriteLit()
    }
}

