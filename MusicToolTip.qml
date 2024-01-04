import QtQuick 2.15

Rectangle {
    id:self
    property alias text: content.text
    property int margin: 15
    color:"white"
    radius:4
    width:content.width+20
    height: content.height+20
    anchors{
           top:getGlobalPosition(parent).y+parent.height+margin+height<Window.height?parent.bottom:undefined
           bottom:getGlobalPosition(parent).y+parent.height+margin+height>=Window.height?parent.top:undefined
           left: (width-parent.width)/2>getGlobalPosition(parent).x?parent.left:undefined
           right:width+getGlobalPosition(parent).x>Window.width?parent.right:undefined
           topMargin: margin
           bottomMargin: margin
       }
    x:(width-parent.width)/2<=parent.x&&width+parent.x<=window.winth?(-width+parent.windth)/2:0
    Text{
        id:content
        text:"这是一段提示文字"
        lineHeight: 1.2
        anchors.centerIn: parent
        font.family: window.mFontFamily
    }

    function getGlobalPosition(targetObject) {
        var positionX = 0
        var positionY = 0
        var obj = targetObject        /* 遍历所有的父窗口 */
        while (obj !== null) {        /* 累加计算坐标 */
            positionX += obj.x
            positionY += obj.y
            obj = obj.parent
        }
        return {x: positionX, y: positionY}
    }
}
