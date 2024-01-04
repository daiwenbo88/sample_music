import QtQuick 2.15
import QtQuick.Layouts

Rectangle {
    id:lyricView
    property string musicId: ""
    property alias lyric: list.model
    property alias current: list.currentIndex

    Layout.preferredHeight: parent.height*0.8
    Layout.alignment: Qt.AlignHCenter
    clip: true
    color: "#00000000"
    ListView{
        id:list
        anchors.fill: parent
        model:["暂无歌词"]
        delegate: listDalegate
//        highlight: Rectangle{
//            color:"#2073a7db"
//        }
        highlightMoveDuration:0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2-50
        preferredHighlightEnd:  parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange
    }
    Component{
        id:listDalegate
        Item{
            id:dalegateItem
            width: list.width
            height: 50
            Text {
                id: name
                text: modelData
                anchors.centerIn: parent
                color: index===list.currentIndex?"#eeffffff":"#aaffffff"
                font {
                    family:window.mFontFamily
                    pointSize: 10
                }
            }
            states: State {
                when:dalegateItem.ListView.isCurrentItem
                PropertyChanges {
                    target: dalegateItem
                    scale:1.2

                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: list.currentIndex=index

            }

        }
    }

}
