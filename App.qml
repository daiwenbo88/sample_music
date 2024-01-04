import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls
import QtQuick.Layouts
import MyUtils 1.0//注册的网络
import QtMultimedia//多媒体播放
import Qt.labs.settings

ApplicationWindow {
    id:window
    property int mWindowWidth: 1200
    property int mWindowHeight: 800

    property string mFontFamily: "微软雅黑"
    width: 1200
    height: 800
    visible: true
    title: qsTr("Demo Cloud Music Player")
    background: Background{
        id:appBackground
    }
    flags: Qt.Window|Qt.FramelessWindowHint//设置无边框
    HttpUtils{
        id:http
    }
    AppSystemTrayIcon{

    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        LayoutHeaderView{
            id:layoutHeaderView
            z:100
        }

        PageHomeView{
            id:pageHomeView

        }
        PageDetailView{
            id:pageDetailView
            visible: false
        }
        //底部工具栏
        LayoutBottmView{
            id:layoutBottmView
        }
    }
    MediaPlayer{
        id:mediaPlayer
        property var times: []
        audioOutput: AudioOutput{}
        onPositionChanged: function(position){
               layoutBottmView.setSlider(0,duration,position)
               if(times.length>0){
                 var count=times.filter(time=>time<=position).length
                 pageDetailView.current=(count==0)?0:count-1
//                for(var i=0;i<times.length;i++){
//                    if(position<times[i]){
//                        pageDetailView.current=i
//                        break
//                    }
//                }
               }
        }
        onPlaybackStateChanged: {
           pageDetailView.playbackState=(playbackState===MediaPlayer.PlayingState)?1:0
           layoutBottmView.playingState=playbackState===MediaPlayer.PlayingState
           layoutBottmView.playIconSource=(playbackState===MediaPlayer.PlayingState)?"icons/images/pause":"icons/images/stop"
            if(playbackState===MediaPlayer.StoppedState&&layoutBottmView.playBackStateChangeCallbackEnabled){
                layoutBottmView.playNext()
            }

        }
    }
    MusicNotification{
        id:notification

    }
    MusicLoading{
        id:loading
    }

    Settings{
        id:settings
        fileName:"conf/settings.ini"
    }
    Settings{
       id:historySttings
       fileName:"conf/history.ini"
    }
    Settings{
       id:favoriteSttings
       fileName:"conf/favorite.ini"
    }



}
