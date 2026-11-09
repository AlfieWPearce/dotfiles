import Quickshell
import QtQuick
import QtQuick.Controls

import "../../services"
import "../../theme"

Item {
    id: root

    implicitWidth: content.implicitWidth + Theme.paddingHorizontal * 2
    implicitHeight: content.implicitHeight + Theme.paddingVertical * 2

    Rectangle {
        anchors.fill: parent
        visible: content.children.some(child => child.visible)
        color: Theme.background
        radius: Theme.radiusMedium
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Theme.spacingMedium

        Text {
          id: wifi
          text: SystemService.wifiConnected ? "󰖩" : "󰖪"

          color: Theme.textPrimary
          font.pixelSize: Theme.fontLarge
          font.weight: Font.Medium
          font.family: Theme.fontFamily
          HoverHandler {
              id: wifiHover
          }
        }
        Text {
          id: bluetooth
          text: SystemService.bluetoothEnabled ? "󰂯" : ""

          color: Theme.textPrimary
          font.pixelSize: Theme.fontLarge
          font.weight: Font.Medium
          font.family: Theme.fontFamily
          HoverHandler {
              id: bluetoothHover
          }
        }
        Item {
          id: battery
          implicitWidth: batteryText.implicitWidth + 12
          implicitHeight: parent.implicitHeight
          Rectangle {
            anchors.fill: parent
            color: Theme.backgroundSecondary
            radius: Theme.radiusSmall
          }
          Text {
            id: batteryText
            anchors.centerIn: parent
            text: !SystemService.batteryPercentVisible ? "" : ((SystemService.batteryCharging ? "󰁹 " : SystemService.batteryCritical ? "󰂃 " : "󰁹 ") + SystemService.batteryPercentage + "%")

            color: Theme.textPrimary
            font.pixelSize: Theme.fontLarge
            font.weight: Font.Medium
            font.family: Theme.fontFamily
          }
          HoverHandler {
              id: batteryHover
          }
        }
        Text {
          id: microphone
          text: SystemService.microphoneInUse ? "󰍬" : ""

          color: Theme.textPrimary
          font.pixelSize: Theme.fontLarge
          font.weight: Font.Medium
          font.family: Theme.fontFamily
          HoverHandler {
              id: microphoneHover
          }
        }
        Text {
          id: camera
          text: SystemService.cameraInUse ? "󰄀" : ""

          color: Theme.textPrimary
          font.pixelSize: Theme.fontLarge
          font.weight: Font.Medium
          font.family: Theme.fontFamily
          HoverHandler {
              id: cameraHover
          }
        }
    }
    StatusTooltip {
        anchorItem: wifi
        hovered: wifiHover.hovered
        text: SystemService.wifiTooltip
    }
    StatusTooltip {
        anchorItem: bluetooth
        hovered: bluetoothHover.hovered
        text: SystemService.bluetoothTooltip
    }
    StatusTooltip {
        anchorItem: battery
        hovered: batteryHover.hovered
        text: SystemService.batteryTooltip
    }
    StatusTooltip {
        anchorItem: microphone
        hovered: microphoneHover.hovered
        text: SystemService.microphoneTooltip
    }
    StatusTooltip {
        anchorItem: camera
        hovered: cameraHover.hovered
        text: SystemService.cameraTooltip
    }

}
