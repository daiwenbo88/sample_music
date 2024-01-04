import QtQuick 2.15
import Qt.labs.platform

SystemTrayIcon {
    id:systemTray
    visible: true
    icon.source: "icons/images/music"

    onActivated: {
        window.show()
        window.raise()
        window.requestActivate()
    }
    menu: Menu{
        id:menu
        MenuItem{
            text: "上一曲"
            onTriggered: {
                layoutBottmView.playPrevious()

            }
        }
        MenuItem{
            text: layoutBottmView.playingState?"播放":"暂停"
            onTriggered: {
                layoutBottmView.playOrpause()

            }
        }
        MenuItem{
            text: "下一曲"
            onTriggered: {
                layoutBottmView.playNext()
            }
        }
        MenuSeparator{}
        MenuItem{
            text: "显示"
            onTriggered: {
                window.show()
            }
        }
        MenuItem{
            text: "退出"
            onTriggered: {
                Qt.quit()
            }
        }
    }

}
