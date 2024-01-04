import QtQuick 2.15
import QtQuick.Controls

ToolButton {
    property string iconSource: ""
    property string toolTip: ""

    property bool isCheckable:false
    property bool isChecked:false

    id:self
    icon.source: iconSource


//    ToolTip.text: toolTip
//    ToolTip.visible: hovered
    MusicToolTip{
        visible: parent.hovered
        text:toolTip
    }
    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#00000000"
        radius: 3
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#00000000":"#eeeeee"
    checkable: isCheckable
    checked: isChecked
}
