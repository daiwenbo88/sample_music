import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQml
Item {
    id:self
    visible: false
    width: 400
    height: 50
    scale: visible

    anchors{
        top:parent.top
        topMargin: 40
        horizontalCenter: parent.horizontalCenter
    }
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
        color:"#03a9f4"
        radius: 5
        Text{
            id:content
            text: "Notification"
            color:"#eeffffff"
            font{
                family: window.mFontFamily
                pointSize: 11
            }
            width: 350
            lineHeight: 25
            lineHeightMode: Text.FixedHeight
            wrapMode: Text.WordWrap
            anchors{
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }
        MusicIconButton{
            iconSource: "icons/images/clear"
            iconWidth: 16
            iconHeight: 16
            toolTip: "关闭"
            anchors{
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            onClicked: close()
        }

    }
    Behavior on scale{
        NumberAnimation{
            easing.type: Easing.InOutBounce
            duration: 200

        }

    }
    Timer{
        id:timer
        interval: 3000
        onTriggered: close()

    }
    function open(text="Notification"){
        close()
        content.text=text
        visible=true
        timer.start()
    }
    function openSuccess(text="Notification"){
        rect.color="#4caf50"
        open(text)
    }
    function openError(text="Notification"){
        rect.color="#ff5252"
        open(text)
    }
    function openWarning(text="Notification"){
        rect.color="#f57c00"
        open(text)
    }
    function openInfo(text="Notification"){
        rect.color="#03a9f4"
        open(text)
    }
    function close(){
        //rect.color="#03a9f4"
        visible=false
        timer.stop()
    }
}
