import QtQuick 2.15
import QtQuick.Controls
import QtQml

Item{
    property alias list: gridRepeter.model
    Grid{
        id:gridLyout
        anchors.fill: parent
        columns: 3
        Repeater{
            id:gridRepeter
            Frame{
                padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                    radius: 6
                }
                clip: true
                MusicRundImage{
                    id:image
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: getCoverImage(modelData.cover)
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id:name
                    text: modelData.name
                    height: parent.height
                    width: parent.width*0.72
                    anchors{
                        left:image.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 5
                    }
                    font{
                        family: window.mFontFamily
                        pointSize: 12
                    }
                    verticalAlignment: Text.AlignVCenter
                    color: "#eeffffff"
                    elide: Qt.ElideMiddle//显示不下就截取
                }
                Text {
                    text: modelData.artist
                    width: parent.width*0.72
                    anchors{
                        left:image.right
                        bottom:image.bottom
                        leftMargin: 5
                    }
                    font{
                        family: window.mFontFamily
                    }
                    color: "#eeffffff"
                    elide: Qt.ElideRight//显示不下就截取
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color="#50ffffff"
                    }
                    onExited: {
                        background.color="#00000000"
                    }
                    onClicked: {
                        var item=gridRepeter.model[index]
                        if(layoutBottmView.musicId!=item.id){
                            //播放单曲
                            layoutBottmView.playList=[{id:item.id,name:item.name,artist:item.artist,album:item.album,cover:item.cover}]
                            layoutBottmView.playMusic(0)
                        }
                    }
                }
            }
        }
    }

    function getCoverImage(coverImage){
        if(coverImage.lastIndexOf("145983724.jpg")>0){
            console.log("coverImage="+coverImage)
            return""
        }
        return coverImage
    }

}
