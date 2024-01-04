import QtQuick 2.15
import QtQuick.Controls
import QtQml
Frame{
    property alias bannerList: bannerView.model//将bannerList 赋值给 bannerView.model
    property int current: 0
    background: Rectangle{
        color: "#00000000"
    }
    PathView{
        id:bannerView
        width: parent.width
        height: parent.height
        clip: true

        delegate: Item{
            id:delegateItem
            width:bannerView.width*0.7
            height: bannerView.height
            z:PathView.z?PathView.z:0
            scale: PathView.scale?PathView.scale:1.0
            MusicRundImage{
                id:image
                imgSrc: modelData.imageUrl
                width:  delegateItem.width
                height: delegateItem.height
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {//点击图片 选中移动到中间
                    var item=bannerView.model[index]
                    var targetId =item.targetId+""
                    var targetType =item.targetType+""//1.单曲 1000歌单 10专辑
                    if(bannerView.currentIndex!=index){
                        bannerView.currentIndex=index
                    }
                    pageHomeView.onPlayListItemClicked(targetId,targetType);
                }
                hoverEnabled: true
                onEntered: {
                    bannerTimer.stop()
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
        pathItemCount: 3//几个item
        path:bannerPath
        preferredHighlightBegin: 0.5//两边缩小 中间保持原样
        preferredHighlightEnd: 0.5
    }

    Path{
        id:bannerPath
        startX: 0
        startY: bannerView.height/2-10
        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.7}
        PathLine{
            x:bannerView.width/2
            y:bannerView.height/2-10
        }
        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.85}
        PathLine{
            x:bannerView.width
            y:bannerView.height/2-10
        }
        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.7}
    }
    //指示器
    PageIndicator{
        id:indicator
        anchors{
            top:bannerView.bottom
            horizontalCenter: parent.horizontalCenter
        }
        count:bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10
        delegate: Rectangle{
            width:20
            height: 5
            radius: 5
            color: index===bannerView.currentIndex?"white":"#55ffffff"
            Behavior on color{

                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    bannerTimer.stop()
                    bannerView.currentIndex=index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }
    Timer{
        id:bannerTimer
        running: true
        repeat: true
        interval:3000
        onTriggered: {
            if(bannerList.length>0){
                bannerView.currentIndex=(bannerView.currentIndex+1)%bannerView.count
            }
        }
    }
}
