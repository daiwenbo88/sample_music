import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
RowLayout{
    property int defaultIndex: 0
    spacing: 0
    ListModel{
        id:menuViewModel
        ListElement{
            icon:"recommend-white"
            value:"推荐内容"
            qml:"DetailRecommendPageView"
            menu:true
        }
        ListElement{
            icon:"cloud-white"
            value:"搜索音乐"
            qml:"DetailSearchPageView"
             menu:true
        }
        ListElement{
            icon:"local-white"
            value:"本地音乐"
            qml:"DetailLocalPageView"
            menu:true

        }
        ListElement{
            icon:"history-white"
            value:"播放历史"
            qml:"DetailHistoryPageView"
            menu:true
        }
        ListElement{
            icon:"favorite-big-white"
            value:"我喜欢的"
            qml:"DetailFavoritePageView"
             menu:true
        }
        ListElement{
            icon:"favorite-big-white"
            value:"专辑歌单"
            qml:"DetailPlayListPageView"
             menu:true
        }
    }


    Frame {
        Layout.fillHeight:true
        Layout.preferredWidth: 200
        background: Rectangle{
            color: "#1000aaaa"
        }
        padding: 0
        ColumnLayout{
            anchors.fill: parent
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                MusicBorderImage {
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius: 100
                }
            }
            ListView{
                id:menuView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: menuViewModel
                clip: true
                delegate: menuViewDelegate
                highlight: Rectangle{//current 选中高亮
                    color:"#3073a7ab"
                }
                highlightMoveDuration: 0//移动动画过渡时间
                highlightResizeDuration: 0//大小改变过渡动画时间
            }
        }

        Component{
            id:menuViewDelegate
            Rectangle{
                //required property int  index
                id:menuViewDelegateItem
                height: 50
                width: 200
                color: "#00000000"
                RowLayout{
                    anchors.fill: parent
                    anchors.centerIn: parent
                    height: 50
                    width: 200
                    spacing: 15
                    Item {
                        width: 30
                    }
                    Image{
                        source: "icons/images/"+icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }
                    Text{
                        text: value
                        Layout.fillWidth: true
                        height: parent.height
                        font.family: window.mFontFamily
                        font.pointSize: 12
                        color: "#eeffffff"
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {//鼠标进入
                         color="#20f0f0f0"
                    }
                    onExited: {
                        color="#00000000"
                    }
                    onClicked: {
                        hidePlayList()
                        var currentIndex =menuViewDelegateItem.ListView.view.currentIndex
                        repeater.itemAt(currentIndex).visible=false//先隐藏当前页面
                       //加载显示选择中页面
                        menuViewDelegateItem.ListView.view.currentIndex=index
                        var loader= repeater.itemAt(index)
                        loader.visible=true
                        console.log(menuViewModel.get(index).qml+".qml")
                        loader.source=menuViewModel.get(index).qml+".qml"
                    }
                }

            }
        }
        Component.onCompleted: {
            var loader= repeater.itemAt(defaultIndex)
            loader.visible=true
            console.log(menuViewModel.get(defaultIndex).qml+".qml")
            loader.source=menuViewModel.get(defaultIndex).qml+".qml"
            menuView.currentIndex=defaultIndex
        }

    }
    Repeater{
        id:repeater
        model:menuViewModel.count
        Loader{
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    function onPlayListItemClicked(targetId,targetType){
        switch(targetType){
        case "1":
            //播放单曲
            layoutBottmView.playList=[{id:targetId,name:"",artist:"",album:"",cover:""}]
            layoutBottmView.playMusic(0)
            break
        case "10":
        case "1000":
            //打开歌单列表
            showPlayList(targetId,targetType)
            break
        }

    }
    function showPlayList(targetId="",targetType="10"){
        repeater.itemAt(menuView.currentIndex).visible=false//先隐藏当前页面
        var loader= repeater.itemAt(5)
        loader.visible=true
        loader.source="DetailPlayListPageView.qml"
        loader.item.targetType=targetType
        console.log("targetId1="+targetId+" targetType="+targetType)
        loader.item.targetId=targetId

    }

    function hidePlayList(){
        repeater.itemAt( menuView.currentIndex).visible=true//显示当前页面
        var loader= repeater.itemAt(5)
        loader.visible=false

    }
}

