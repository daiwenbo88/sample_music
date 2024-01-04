import QtQuick 2.15
import QtQuick.Controls

Button {
    property alias btnText: btnText.text
    property alias btnWidth: self.width
    property alias btnHeight: self.height
    property alias isCheckable:self.checkable
    property alias isChecked:self.checked

    id:self

    height:35
    width: 50
    background: Rectangle{
        implicitHeight: self.height
        implicitWidth: self.width
        color: self.down||(self.checkable&&self.checked)?"#e2f0f8":"#66e9f4ff"
        radius: 3
    }

    checkable: false
    checked: false
    Text {
        id: btnText
        text: "Button"
        color:self.down||(self.checkable&&self.checked)?"#ee000000":"#eeffffff"
        font.family: window.mFontFamily
        font.pointSize: 14
        anchors.centerIn:parent
    }

}
