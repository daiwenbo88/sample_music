import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    property string imgSrc: "/icons/images/player"
    property int borderRadius: 5
    Image {
        id:image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        //asynchronous: true// 开启异步加载模式，专门使用一个线程来加载图片
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        antialiasing: true//抗锯齿
        visible: false

    }
    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        antialiasing: true
    }
    OpacityMask{
        anchors.fill: image
        source: image
        maskSource:mask
        visible: true
        antialiasing: true
    }
}
