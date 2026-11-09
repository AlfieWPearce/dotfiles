import Quickshell
import QtQuick

import "../../theme"

Row {
    id: root
    spacing: 16

    property string timeHours: "00"
    property string timeMinutes: "00"
    property string artist: ""
    property string title: ""

    property int maxMusicWidth: 300

    readonly property string trackText: artist + " — " + title

    // Clock: left
    Text {
        id: hours

        text: root.timeHours
        color: Theme.textPrimary
        font.pixelSize: Theme.fontLarge
        font.weight: Font.Medium
        font.family: Theme.fontFamily

        anchors.verticalCenter: parent.verticalCenter
    }

    // Track information: middle
    Item {
        id: viewport

        property int padding: Theme.spacingMedium

        // Grow to fit text, but stop at maxMusicWidth
        width: Math.min(trackLabel.implicitWidth, root.maxMusicWidth) + padding * 2
        height: 30

        clip: true


        Rectangle {
          anchors.fill: parent
          color: Theme.backgroundSecondary
          radius: Theme.radiusMedium
          z: -1
        }

        Text {
            id: trackLabel

            x: viewport.padding
            text: root.trackText
            color: Theme.textPrimary
            font.pixelSize: Theme.fontSmall
            font.family: Theme.fontFamily

            anchors.verticalCenter: parent.verticalCenter

            SequentialAnimation {
                id: marquee

                running: trackLabel.implicitWidth > viewport.width
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 1200
                }

                NumberAnimation {
                    target: trackLabel
                    property: "x"
                    to: viewport.width - trackLabel.implicitWidth - Theme.spacingMedium
                    duration: Math.max(
                        3000,
                        (trackLabel.implicitWidth - viewport.width) * 35
                    )
                    easing.type: Easing.Linear
                }

                PauseAnimation {
                    duration: 1200
                }

                NumberAnimation {
                    target: trackLabel
                    property: "x"
                    to: Theme.spacingMedium
                    duration: Math.max(
                        3000,
                        (trackLabel.implicitWidth - viewport.width) * 35
                    )
                    easing.type: Easing.Linear
                }
            }

            // Reset scrolling when the track changes
            onTextChanged: {
                marquee.stop()
                x = Theme.spacingMedium

                if (implicitWidth > viewport.width)
                    marquee.start()
            }
        }
    }

    // Clock: right
    Text {
        id: minutes

        text: root.timeMinutes
        color: Theme.textPrimary
        font.pixelSize: Theme.fontLarge
        font.weight: Font.Medium
        font.family: Theme.fontFamily

        anchors.verticalCenter: parent.verticalCenter
    }
}
