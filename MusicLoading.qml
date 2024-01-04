import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQml
Item {
    id:self
    visible: false
    width: 180
    height:180
    scale: visible

    anchors.centerIn: parent
    //阴影
    DropShadow{
        anchors.fill: rect
        radius: 8.0
        horizontalOffset: 1
        verticalOffset: 1
        samples: 16
        color: "#90000000"
        source: rect
    }
    Rectangle{
        id:rect
        anchors.fill: parent
        color:"#5003a9f4"
        radius: 5
        Image {
            id: image
            source: "icons/images/loading"
            width: 50
            height: 50
            anchors.centerIn: parent
            NumberAnimation{
                duration: 600
                to:360
                from:0
                target: image
                running: true
                loops: Animation.Infinite
                property: "rotation"
            }
        }
        Text{
            id:content
            text: "Loading"
            color:"#eeffffff"
            font{
                family: window.mFontFamily
                pointSize: 11
            }

            anchors{
                top: image.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }

    }


    function open(){
        visible=true
    }

    function close(){
        visible=false
    }
}
