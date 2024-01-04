import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window 2.15
import QtMultimedia
Rectangle{
    property point point: Qt.point(x,y)
    Layout.fillWidth: true
    height: 60
    color:"#1500AAAA"
    property var playList: []
    property int current: 0
    property int sliderTo: 100
    property int sliderFrom: 0
    property int sliderValue: 0

    property var playModeList: [{icon:"single-repeat",name:"单曲循环"},{icon:"repeat",name:"顺序播放"},{icon:"random",name:"随机播放"}]
    property int currentPlayMode: 0
    property bool playBackStateChangeCallbackEnabled: false

    property string musicCoverImg: "/icons/images/player"// This is available in all editors.
    property string musicName: "徐佳莹"
    property string musicArtist: "徐佳莹"
    property string musicId: ""
    property string playIconSource: "icons/images/stop"
    property bool playingState: false

    RowLayout{
        anchors.fill: parent
        Item {
            Layout.preferredWidth:parent.width/10
            Layout.fillHeight: true
            Layout.fillWidth: true
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setPoint(mouseX,mouseY)
                }
                onMouseXChanged: {
                    setXMove(mouseX)
                }
                onMouseYChanged: {
                    setYMove(mouseY)
                }

            }
        }
        MusicIconButton{
            iconWidth: 32
            iconHeight: 32
            iconSource: "icons/images/previous"
            toolTip: "上一曲"
            onClicked:{
                playPrevious()
            }
        }
        MusicIconButton{
            id:btnPlay
            iconWidth: 32
            iconHeight: 32
            iconSource: playIconSource
            toolTip: playingState?"暂停":"播放"
            onClicked:playOrpause()
        }
        MusicIconButton{
            id:btnNext
            iconWidth: 32
            iconHeight: 32
            iconSource: "icons/images/next"
            toolTip: "下一曲"
            onClicked:{
                playNext()
            }
        }
        Item {
            Layout.preferredWidth:parent.width/2
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.topMargin: 10
            Text {

                anchors.left: slider.left
                anchors.bottom: slider.top
                anchors.bottomMargin: -4
                anchors.leftMargin: 5
                text: musicName+"-"+musicArtist
                font.family: window.mFontFamily
                color:"#ffffff"
                visible: !layoutHeaderView.isSmallWindow
            }
            Text {
                id:timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                anchors.bottomMargin: -4
                anchors.rightMargin: 5
                text: qsTr("00:00/05:30")
                font.family:window.mFontFamily
                color:"#ffffff"
                visible: !layoutHeaderView.isSmallWindow
            }
            Slider{
                id:slider
                anchors.centerIn: parent
                width: parent.width
                Layout.fillWidth: true
                height: 25
                to:sliderTo
                from:sliderFrom
                value:sliderValue
                visible: !layoutHeaderView.isSmallWindow
                onMoved:{
                    mediaPlayer.setPosition(value)
                }
                background: Rectangle{
                    x:slider.leftPadding
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: slider.availableWidth//可用宽度
                    height: 4
                    radius: 2
                    color:"#e9f4ff"
                    Rectangle{
                        width: slider.visualPosition*parent.width
                        height: parent.height
                        color:"#8cecf3"
                        radius: 2
                    }
                }
                handle: Rectangle{
                    x:slider.leftPadding+(slider.availableWidth-width)*slider.visualPosition
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: 15
                    height: 15
                    radius: 5
                    color:"#f0f0f0"
                    border.color:"#73a7ab"
                    border.width: 0.5
                }

            }
        }
        MusicBorderImage{
            id:musicCover
            width:50
            height: 50
            borderRadius: 25
            imgSrc: musicCoverImg
             visible: !layoutHeaderView.isSmallWindow
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    musicCover.scale=0.9
                }
                onReleased: {
                    musicCover.scale=1.0
                }
                onClicked: {
                    pageDetailView.visible=!pageDetailView.visible
                    pageHomeView.visible=!pageHomeView.visible

                }
            }
        }
        MusicIconButton{
            iconWidth: 32
            iconHeight: 32
            iconSource: "icons/images/favorite"
            toolTip: "我喜欢"
            onClicked: {
                var item=playList[current]
                saveFavorite(item)
            }
        }
        MusicIconButton{
            iconWidth: 32
            iconHeight: 32
            iconSource: "icons/images/"+playModeList[currentPlayMode].icon
            toolTip: playModeList[currentPlayMode].name
            onClicked: playModeChanged()
        }
        Item {
            Layout.preferredWidth:parent.width/10
            Layout.fillHeight: true
            Layout.fillWidth: true
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setPoint(mouseX,mouseY)
                }
                onMouseXChanged: {
                    setXMove(mouseX)
                }
                onMouseYChanged: {
                    setYMove(mouseY)
                }

            }
        }

    }
    Component.onCompleted: {
        currentPlayMode=settings.value("playMode",0)
        console.log("currentPlayMode="+currentPlayMode)

    }
    onCurrentChanged: {
        playBackStateChangeCallbackEnabled=false
    }
    function playOrpause(){
        if(!mediaPlayer.source){
            return
        }
        if(mediaPlayer.playbackState===MediaPlayer.PlayingState){
            mediaPlayer.pause()
            musicCover.iconSource="icons/images/pause.png"
        }else if(mediaPlayer.playbackState===MediaPlayer.PausedState){
            mediaPlayer.play()
            musicCover.iconSource="icons/images/stop"
        }

    }
    function setPoint(mouseX,mouseY){
        point=Qt.point(mouseX,mouseY)
    }
    function setXMove(mouseX){
        var x=window.x+mouseX-point.x
        if(x<-(window.width-70)){
            x=-(window.width-70)
        }
        if(x>Screen.desktopAvailableWidth-70){
            x=Screen.desktopAvailableWidth-70
        }
        window.x=x
    }

    function setYMouse(mouseY){
        var y=window.y+mouseY-point.y
        if(y<0){
            y=0
        }
        if(y>Screen.desktopAvailableHeight-70){
            y=Screen.desktopAvailableHeight-70
        }
         window.y=y
    }

    function playPrevious(){
        if(playList.length>0){
            switch(currentPlayMode){
            case 0:
                break;
            case 1:
                current=(current+playList.length-1)%playList.length
                break;
            case 2:
                current=parseInt(Math.random()*playList.length)
                break;

            }
            playMusic(current)
        }
    }

    function playNext(){
        if(playList.length>0){

            switch(currentPlayMode){
            case 0:
                break;
            case 1:
                current=(current+1)%playList.length
                break;
            case 2:
                current=parseInt(Math.random()*playList.length)
                break;

            }
            playMusic(current)
        }
    }
    function playModeChanged(){
        currentPlayMode=(currentPlayMode+1)%playModeList.length
        settings.setValue("playMode",currentPlayMode)

    }
    function stopPlay(){
        mediaPlayer.stop()
    }

    function playMusic(index=0){
        ///song/detail?ids=347230
        current=index
        var obj =playList[index]
        var type=obj.type
        if(type=="1"){//播放本地音乐
            mediaPlayer.source=obj.url
            mediaPlayer.play()
            setPlayInfo(index)
            var imageUrl=obj.cover
            if(imageUrl.length<1){
                musicCoverImg="icons/images/player"
            }else{
                musicCoverImg=imageUrl
            }
            saveHistory()
        }else{
            var id=playList[index].id
            if(id.length<0||musicId===id)return
             musicId=id
            console.log(" play id="+id)
            loading.open()
            stopPlay()
            getUrl(id,index)
            setPlayInfo(index)
        }
    }

    function setPlayInfo(index){
        musicName=playList[index].name
        musicArtist=playList[index].artist
    }
    function getCover(id,index){
        let obj=playList[index]

        var imageUrl=obj.cover
        if(imageUrl.length<1){
            function onReply(reply){

                http.onReplySignal.disconnect(onReply);//断开连接
                getLyric(id)
                try{
                    var obg=JSON.parse(reply).songs[0]
                    var cover=obg.al.picUrl
                    musicName=obg.al.name
                    musicArtist=obg.ar[0].name
                    console.log(" play cover="+cover)
                    if(cover){
                        musicCoverImg=cover
                    }
                }catch(e){                    
                    notification.openError("请求歌曲图片出错")
                }

            }
            http.onReplySignal.connect(onReply)//建立连接
            http.doConnet("song/detail?ids="+id)//发起网络请求
        }else{
           musicCoverImg=imageUrl
            getLyric(id)
        }

    }
    function setSlider(from=0,to=100,value=0){
        sliderFrom=from
        sliderTo=to
        sliderValue=value
        var v_mm=parseInt(value/1000/60)+""
        v_mm=v_mm.length<2?"0"+v_mm:v_mm
        var v_ss=parseInt(value/1000%60)+""
        v_ss=v_ss.length<2?"0"+v_ss:v_ss

        var to_mm=parseInt(to/1000/60)+""
        to_mm=to_mm.length<2?"0"+to_mm:to_mm
        var to_ss=parseInt(to/1000%60)+""
        to_ss=to_ss.length<2?"0"+to_ss:to_ss

        timeText.text=v_mm+":"+v_ss+"/"+to_mm+":"+to_ss+"/"

    }

    //获取播放链接
    function getUrl(id,index){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply);//断开连接
            if(reply.length<1){
                notification.openError("请求歌曲链接出错")
                return
            }
            try{
                var json= JSON.parse(reply).data[0]
                var url=json.url
                var time=json.time

                setSlider(0,time,0);
                getCover(id,current)
                if(!url)return
                console.log("url="+url)
                mediaPlayer.source=url
                mediaPlayer.play()
                playBackStateChangeCallbackEnabled=true
                btnPlay.iconSource="icons/images/stop"
                saveHistory()
            }catch(e){

                getCover(id,current)
                saveHistory()
                notification.openError("请求歌曲链接出错")
            }

        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("song/url?id="+id)//发起网络请求
    }

    function getLyric(id){
        function onReply(reply){
            //console.log(reply)
            loading.close()
            http.onReplySignal.disconnect(onReply);//断开连接

            try{
                if(reply.length<1){
                    notification.openError("请求歌曲歌词为空")
                    return
                }
                var lyric=JSON.parse(reply).lrc.lyric
                var lyrics= (lyric.replace(/\[.*\]/gi,"")).split("\n")
                if(lyrics.length>0){
                    console.log("lyricsa="+lyrics.length)
                    pageDetailView.lyricsList=lyrics
                    var times=[]
                    lyric.replace(/\[.*\]/gi,function(macth,index){
                        if(macth.length>2){
                            var time=macth.substr(1,macth.length-2)
                            var arr=time.split(":")
                            var timeValue= (arr.length>0)?parseInt(arr[0])*60*1000:0
                            arr=arr.length>1?arr[1].split("."):[0,0]
                            timeValue+=(arr.length>0)?parseInt(arr[0])*1000:0
                            timeValue+=(arr.length>1)?parseInt(arr[1])*10:0
                            times.push(timeValue)
                        }

                    })
                    mediaPlayer.times=times
                }
            }catch(e){
                console.log(e)
                notification.openError("请求歌曲歌词出错")
            }
        }
        http.onReplySignal.connect(onReply)//建立连接
        http.doConnet("lyric?id="+id)//发起网络请求
    }
    function saveFavorite(item){
        var favorite= favoriteSttings.value("favorite","")
        //console.log("favorite= " + favorite);
        var favoriteList=(favorite.length>0)?JSON.parse(favorite):[]

        var i= favoriteList.findIndex(value=>value.id===item.id)//查找是否有相同的歌曲
        if(i>0){
            favoriteList.splice(i,1)//代表已经在喜欢的列表 截取数组的一部分，并返回这个新的数组
        }else{
            favoriteList.unshift({
                                    id:item.id,
                                    name:item.name,
                                    artist:item.artist,
                                    url:item.path?item.path:"",
                                    album:item.album,
                                    type:item.type?item.type:"",
                                    cover:item.cover?item.cover:"icons/images/player"
                                })
        }

       // console.log("favorite= " + JSON.stringify(favoriteList));
       favoriteSttings.setValue("favorite",JSON.stringify(favoriteList))

    }

    function saveHistory(){
        var item=playList[current]
        var history= historySttings.value("history","")
        //console.log("history= " + history);
        var historyList=(history.length>0)?JSON.parse(history):[]

        var i= historyList.findIndex(value=>value.id===item.id)//查找是否有相同的歌曲
        if(i>0){
            historyList.splice(i,1)//

        }
        historyList.unshift({
                                id:item.id,
                                name:item.name,
                                artist:item.artist,
                                url:item.path?item.path:"",
                                album:item.album,
                                type:item.type?item.type:"",
                                cover:item.cover?item.cover:"icons/images/player"
                            })
        if(historyList.length>100){
           historyList.pop()//限制100条数据
        }
         //console.log("history= " + JSON.stringify(historyList));
        historySttings.setValue("history",JSON.stringify(historyList))

    }
}
