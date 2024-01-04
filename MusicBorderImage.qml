import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    property string imgSrc: "/icons/images/player"
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0
    radius:borderRadius
    gradient:  Gradient{
        GradientStop{
            position: 0.0
            color:"#101010"
        }
        GradientStop{
            position: 0.5
            color:"#a0a0a0"
        }
        GradientStop{
            position: 1.0
            color:"#505050"
        }
    }

    Image {
        id:image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        //asynchronous: true// 开启异步加载模式，专门使用一个线程来加载图片
        width: parent.width*0.9
        height: parent.height*0.9
        fillMode: Image.PreserveAspectCrop
        antialiasing: true//抗锯齿
        visible: false

    }
    //蒙板 遮罩
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
        id:maskImage
        anchors.fill: image
        source: image
        maskSource:mask
        visible: true
        antialiasing: true
    }

    NumberAnimation {
        running: isRotating
        loops:Animation.Infinite
        from: rotationAngel
        target: maskImage
        to:360+rotationAngel
        property: "rotation"
        duration: 10000

        onStopped: {
            rotationAngel=maskImage.rotation
        }
    }
}
