import QtQuick 2.15
import QtQuick.Controls
import QtQml
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtQuick.Shapes
Frame{
    property var musicList:[]
    property int all:0
    property int pageSize:60
    property int current:0
    property int offset: 0
    property bool deleteble: true
    property bool favoritable: true

    signal loadMoreData(int offset)
    signal deleteItem(int index)
    clip: true
    onMusicListChanged: {
         listViewModel.clear()
        if(musicList.length>0){
            listViewModel.append(musicList)
            offset+=musicList.length
        }
    }
    Layout.fillHeight: true
    Layout.fillWidth: true
    padding: 0
    spacing: 0
    background: Rectangle{
        color: "#00000000"
    }
    ColumnLayout{
        anchors.fill: parent
        Rectangle{
            id:listViewHeader
            color: "#1000aaaa"
            z:100
            height: 45
            width: parent.width
            Layout.fillWidth: true
            //anchors.bottom: listView.top
            //anchors.top: parent.top
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x:5
                Text {
                    text: qsTr("序号")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width*0.05
                    font.pointSize: 13
                    color: "#eeffffff"
                    elide: Qt.ElideRight
                }
                Text {
                    text:qsTr("歌名")
                    //horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width*0.4
                    font.pointSize: 13
                    color: "#eeffffff"
                    elide: Qt.ElideRight
                }
                Text {
                    text:qsTr("歌手")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.pointSize: 13
                    color: "#eeffffff"
                    elide: Qt.ElideRight
                }
                Text {
                    text: qsTr("专辑")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.pointSize: 13
                    color: "#eeffffff"
                    elide: Qt.ElideRight
                }
                Text {
                    text: qsTr("操作")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.pointSize: 13
                    color: "#eeffffff"
                    elide: Qt.ElideRight
                }
            }
        }
        ListView{
            id:listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            //width: parent.width
            //height: parent.height - y
            anchors.bottomMargin: 45
            //anchors.top: listViewHeader.bottom
            model: ListModel{
                id:listViewModel
            }
            delegate: listViewDelegate
            ScrollBar.vertical: ScrollBar{
                anchors.right: parent.right
            }
            highlight: Rectangle{
                color: "#3073a7ab"
            }
            highlightMoveDuration: 0
            highlightResizeDuration: 0
        }

        Component{
            id:listViewDelegate
            Rectangle{
                id:delegateItem
                height: 45
                width: listView.width
                color:"#00000000"
                //绘制分割线
                Shape{
                    anchors.fill: parent
                    ShapePath{
                        strokeWidth: 0
                        strokeColor: "#50000000"
                        strokeStyle: ShapePath.SolidLine
                        startX: 0
                        startY: 45
                        PathLine{
                            x:0
                            y:45
                        }
                        PathLine{
                            x:delegateItem.width
                            y:45
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        color="#20f0f0f0"
                    }
                    onExited: {
                        color="#00000000"
                    }
                    onClicked: {
                        //点击设置选中
                        delegateItem.ListView.view.currentIndex=index

                    }
                }
                RowLayout{
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x:5
                    Text {
                        text: index+1+pageSize*current
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: parent.width*0.05
                        font.pointSize: 13
                        color: "#eeffffff"
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: name
                        //horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: parent.width*0.4
                        font.pointSize: 13
                        color: "#eeffffff"
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: artist
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.pointSize: 13
                        color: "#eeffffff"
                        elide: Qt.ElideMiddle
                    }
                    Text {
                        text: album
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.pointSize: 13
                       color: "#eeffffff"
                        elide: Qt.ElideMiddle
                    }
                    Item {
                        Layout.preferredWidth: parent.width*0.15
                        RowLayout{
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "/icons/images/pause"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                isChecked:true
                                onClicked: {
                                     console.log("MouseArea cover="+musicList[index].cover)
                                    layoutBottmView.playList=musicList
                                    layoutBottmView.musicCoverImg=musicList[index].cover
                                    layoutBottmView.playMusic(index)
                                }
                            }
                            MusicIconButton{
                                visible: favoritable
                                iconSource: "/icons/images/favorite"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "喜欢"
                                isChecked:true
                                onClicked: {
                                    console.log("favorite="+musicList[index].id)
                                    var item=musicList[index]
                                    layoutBottmView.saveFavorite(item)
                                }
                            }
                            MusicIconButton{
                                visible: deleteble
                                iconSource: "/icons/images/clear"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "删除"
                                isChecked:true
                                onClicked: {
                                    deleteItem(index)
                                }
                            }
                        }
                    }
                }

            }
        }

        Item {
            id: pageButton
            visible: musicList.length!=0&&all!=0
            Layout.fillWidth: true
            height: 40
            ButtonGroup{
                buttons: buttons.children
            }
            RowLayout{
                id:buttons
                anchors.centerIn: parent
                Repeater{
                    id:repeater
                    model: all/pageSize>9?9:all/pageSize
                    Button{
                        Text {
                            anchors.centerIn: parent
                            text: modelData+1
                            font.family: window.mFontFamily
                            font.pointSize:14
                            color:checked?"#497563":"#eeffffff"
                        }
                        background: Rectangle{
                            implicitHeight: 30
                            implicitWidth: 30
                            color:checked?"#e2f0f8":"#20e9f4ff"
                        }
                        checkable: true
                        checked: index===current
                        onClicked: {
                            if(current!==index){
                                current=index
                                loadMoreData(offset)
                            }

                        }
                    }
                }
            }
        }


    }



}
