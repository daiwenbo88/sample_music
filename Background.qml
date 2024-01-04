import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {
    property bool showDefaultBackground: false

    Image{
        id:backgroundImage
        source: showDefaultBackground?"icons/images/player":layoutBottmView.musicCoverImg
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }
    //高斯模糊
    ColorOverlay{
        id:backgroundImageOverlay
        anchors.fill: parent
        source: backgroundImage
        color: "#35000000"
    }
    FastBlur{
        anchors.fill: backgroundImageOverlay
        source: backgroundImageOverlay
        radius:80
    }

}
