import Quickshell
import QtQuick

import "../../services"
import "../../theme"

Item {
    id: root

    readonly property bool musicPlaying: MprisService.isPlaying
    readonly property int contentWidth: musicPlaying ? musicDisplay.implicitWidth : idleDisplay.implicitWidth
    property bool dashboardControllerOpened

    opacity: dashboardControllerOpened ? 0 : 1
    scale: dashboardControllerOpened ? 0.8 : 1
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 350
            easing.type: Easing.InOutCubic
        }
    }

    implicitWidth: contentWidth + Theme.paddingHorizontal * 2
    implicitHeight: 30 + Theme.paddingVertical * 2

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: Theme.radiusMedium
    }

    IdleDisplay {
        id: idleDisplay
        anchors.centerIn: parent
        time: ClockService.timeShort
        visible: !root.musicPlaying
    }

    MusicDisplay {
        id: musicDisplay
        anchors.centerIn: parent

        timeHours: ClockService.hour.toString().padStart(2, "0")
        timeMinutes: ClockService.minute.toString().padStart(2, "0")

        artist: MprisService.artist
        title: MprisService.title

        visible: root.musicPlaying
    }
}
