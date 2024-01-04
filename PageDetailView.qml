import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
Item {
    Layout.fillHeight: true
    Layout.fillWidth: true
    property int playbackState: 1
    property alias lyricsList: lyricView.lyric
    property alias current: lyricView.current
    RowLayout{
        anchors.fill: parent
        Frame{
            Layout.preferredWidth: parent.width*0.45
            Layout.fillHeight: true
            Layout.fillWidth: true
            background: Rectangle{
                color: "#00000000"
            }
            Text{
                id:name
                text:  layoutBottmView.musicName
                anchors{
                    bottom: artist.top
                    bottomMargin: 20

                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFontFamily
                    pointSize: 16
                }
                color: "#eeffffff"
            }
            Text{
                id:artist
                text: layoutBottmView.musicArtist
                anchors{
                    bottom: cover.top
                    bottomMargin: 50
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFontFamily
                    pointSize: 14
                }
                color: "#aaffffff"
            }

            MusicBorderImage{
                id:cover
                width: parent.width*0.6
                height: width
                borderRadius: width
                anchors.centerIn:parent
                imgSrc: layoutBottmView.musicCoverImg
                isRotating:playbackState==1
            }
            Text{
                id:lyric
                visible: layoutHeaderView.isSmallWindow
                Layout.fillWidth: true
                width: parent.width
                text: lyricView.lyric[current]?lyricView.lyric[current]:"暂无歌词"
                anchors{
                    top: cover.bottom
                    topMargin: 20
                    leftMargin: 8
                    rightMargin: 8
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFontFamily
                    pointSize: 14
                }
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap//换行效果
                color: "#aaffffff"
            }
            MouseArea{
                id:mouseArea
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {
                    displayHeaderAndBottom(false)
                }
                onExited: {
                    displayHeaderAndBottom(true)
                }
                onMouseXChanged:{
                    timer.stop()
                    cursorShape=Qt.ArrowCursor
                    timer.start()
                }
                onClicked: {
                    timer.stop()
                    displayHeaderAndBottom(true)
                }

            }

        }
        Frame{
            Layout.preferredWidth: parent.width*0.55
            Layout.fillHeight: true
            visible: !layoutHeaderView.isSmallWindow
            background: Rectangle{
                color: "#0000aaaa"
            }
            MusicLyricView{
                id:lyricView
                anchors.fill: parent

            }
        }
    }
    Timer{
        id:timer
        interval: 3000
        onTriggered: {
            mouseArea.cursorShape=Qt.BlankCursor
            displayHeaderAndBottom(false)
        }
    }
    function displayHeaderAndBottom(visible=true){
        layoutHeaderView.visible=pageHomeView.visible||visible
        layoutBottmView.visible=pageHomeView.visible||visible
    }
}
