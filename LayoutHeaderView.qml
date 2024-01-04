import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
ToolBar{
    property point point: Qt.point(x,y)
    property bool isSmallWindow: false
    background: Rectangle{
        color: "#00000000"
    }
    Layout.fillWidth: true
    width: parent.width
    height: 32
    RowLayout{
        anchors.fill: parent
        MusicToolButton{
            iconSource: "icons/images/music.ico"
            width: 32
            height: 32
            toolTip: "关于"
            onClicked: {
                aboutPopup.open()
            }
        }
        MusicToolButton{
            iconSource: "icons/images/about"
            width: 32
            height: 32
            toolTip: "关于"
            onClicked: {
                //打开一个外部网页
                Qt.openUrlExternally("https://www.hyz.cool")

            }
        }
        MusicToolButton{
            id:smallWindow
            iconSource: "icons/images/small-window"
            width: 32
            height: 32
            toolTip: "小窗播放"
            visible: !isSmallWindow
            onClicked: {
                setWindowSize(330,650);

                pageHomeView.visible=false
                pageDetailView.visible=true
                isSmallWindow=true
                //appBackground.showDefaultBackground=true
            }
        }
        MusicToolButton{
            id:normalWindow
            iconSource: "icons/images/exit-small-window"
            width: 32
            height: 32
            toolTip: "退出小窗播放"

            visible: isSmallWindow
            onClicked: {

                setWindowSize();
                isSmallWindow=false

            }
        }
        Item {
            Layout.fillWidth: true
            height: 32
            Text {
                anchors.centerIn: parent

                font.family: "微软雅黑"
                font.pointSize: 15
                color: "#eeffffff"
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    setPoint(mouseX,mouseY)
                }
                onMouseXChanged: {
                    setXMove(mouseX)
                }
                onMouseYChanged: {
                    setYMove(mouseY)
                }
            }
        }
        MusicToolButton{
            iconSource: "icons/images/minimize-screen"
            width: 32
            height: 32
            toolTip: "最小化"
            onClicked: {
                window.hide()
            }
        }
        MusicToolButton{
            id:maxWindow
            iconSource: "icons/images/full-screen"
            width: 32
            height: 32
            toolTip: "全屏"
            onClicked: {
                window.visibility=Window.Maximized
                visible=false
                resize.visible=true
            }
        }
        MusicToolButton{
            id:resize
            iconSource: "icons/images/small-screen"
            width: 32
            height: 32
            toolTip: "退出全屏"
            visible:false
            onClicked: {
                setWindowSize()
                 window.visibility=Window.AutomaticVisibility
                visible=false
                maxWindow.visible=true
            }
        }
        MusicToolButton{
            iconSource: "icons/images/power.png"
            width: 32
            height: 32
            toolTip: "退出"
            onClicked: {
                Qt.quit()
            }
        }
    }
    Popup{
        id:aboutPopup
        parent: Overlay.overlay
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        width: 250
        height: 230
        topInset:0
        leftInset:0
        bottomInset:0
        rightInset:0

        background: Rectangle{
            color:"#e9f4ff"
            radius: 5
            border.color: "#2273a7ab"
        }
        contentItem: ColumnLayout{
            width:parent.width
            height: parent.height
            //Layout.alignment:
            Image {
                Layout.preferredHeight: 60
                source: "/icons/images/music"
                 Layout.fillWidth: true
                fillMode: Image.PreserveAspectFit
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("徐佳莹")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color:"#8573a7ab"
                font.family: window.mFontFamily
                font.bold: true
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("Cloud Music Player")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color:"#8573a7ab"
                font.family:  window.mFontFamily
                font.bold: true
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("www.hyz.cool")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color:"#8573a7ab"
                font.family:  window.mFontFamily
                font.bold: true
            }

        }
    }
    function setWindowSize(width=window.mWindowWidth,height=window.mWindowHeight){
        window.height=height
        window.width=width
        window.x=(Screen.desktopAvailableWidth-window.width)/2
        window.y=(Screen.desktopAvailableHeight-window.height)/2

    }

    function setPoint(mouseX,mouseY){
        point=Qt.point(mouseX,mouseY)
    }
    function setXMove(mouseX){
        var x=window.x+mouseX-point.x
        if(x<-(window.width-70)){
            x=-(window.width-70)
        }
        if(x>Screen.desktopAvailableWidth-70){
            x=Screen.desktopAvailableWidth-70
        }
        window.x=x
    }

    function setYMouse(mouseY){
        var y=window.y+mouseY-point.y
        if(y<0){
            y=0
        }
        if(y>Screen.desktopAvailableHeight-70){
            y=Screen.desktopAvailableHeight-70
        }
         window.y=y
    }
}

