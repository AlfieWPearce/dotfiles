
import Quickshell
import QtQuick

import "../../theme"

PopupWindow {
    id: root

    required property Item anchorItem
    required property bool hovered
    required property string text

    width: 220
    height: tooltipText.implicitHeight + 20

    color: "transparent"

    anchor.item: anchorItem

    anchor.rect.x: anchorItem.width / 2 - width / 2
    anchor.rect.y: anchorItem.height + 3 + 5
    anchor.rect.width: 1
    anchor.rect.height: 1

    anchor.edges: Edges.Top | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right

    visible: hovered || popupHover.hovered

    Rectangle {
        anchors.fill: parent

        color: Theme.background
        radius: Theme.radiusMedium

        HoverHandler {
            id: popupHover
        }

        Text {
            id: tooltipText

            anchors.fill: parent
            anchors.margins: 10

            text: root.text

            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSmall

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }
}

