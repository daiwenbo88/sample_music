import QtQuick 2.15
import QtQuick.Controls
import QtQml

Item{
    property alias list: gridRepeter.model
    Grid{
        id:gridLyout
        anchors.fill: parent
        columns: 5
        Repeater{
            id:gridRepeter
            Frame{
                padding: 8
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                    radius: 6
                }
                clip: true
                MusicRundImage{
                    id:image
                    width: parent.width
                    height: parent.width
                    imgSrc: getCoverImage(modelData.coverImgUrl)
                }

                Text {
                    text: modelData.name
                    width: parent.width
                    height: 30
                    anchors{
                        top:image.bottom
                        horizontalCenter: parent.horizontalCenter
                        leftMargin: 5
                        rightMargin: 5
                    }
                    font{
                        family: window.mFontFamily
                        pointSize: 12
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "#eeffffff"
                    elide: Qt.ElideMiddle//显示不下就截取
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
                         pageHomeView.onPlayListItemClicked(item.id,"1000");
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
